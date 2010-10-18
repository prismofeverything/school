from itertools import chain

import numpy as np
import neuron

import plot

#load_mechanisms('/Users/rspangler/school/computationalneuroscience/neuron/hh_zoo')
neuron.h.nrn_load_dll('/Users/rspangler/school/computationalneuroscience/neuron/hh_zoo/x86_64/.libs/libnrnmech.so')

def assign_hoc_globals(hoc):
    for key in hoc.keys():
        neuron.h(key + ' = ' + str(hoc[key]))

# hoc_labels = {
#     'gna': 'Sodium Conductance (uS)'
# }

# mechanisms is a list of mechanism strings (such as 'hh' or 'iC')
# recordings is a dict with sub-entries 'global' and 'soma', pointing to the various
#   attributes to record during this soma's runs
# settings is a hash containing any other initial values for hoc
class Soma:
    def __init__(self, mechanisms=[], recording={}, settings={}):
        self.dt = settings['dt'] if settings.has_key('dt') else 0.025
        self.settings = {
            'celsius': 15,
            'v_init': -70,
            'g_passive': .0003,
            'erev_passive': -70,
            'gnaHH': .12,
            'gkHH': .036,
            'glHH': .0003
        }

        self.settings.update(settings)
        self.mechanisms = mechanisms

        self.recording = {}
        self.recording.update(recording)

        default_locations = [('global', 't', 'Time (ms)'), ('soma', 'v', 'Membrane Potential (mV)')]
        for location, parameter, label in default_locations:
            if not location in self.recording:
                self.recording[location] = {}
            if not parameter in self.recording[location]:
                self.recording[location][parameter] = label
        
        self.soma = self.build_soma()
        self.clamp = self.build_clamp(self.soma)

        self.initialize()

    def build_soma(self):
        soma = neuron.h.Section()
        soma.nseg = 1
        soma.diam = 20
        soma.L = 20
        soma.Ra = 100

        for mechanism in self.mechanisms:
            soma.insert(mechanism)

        return soma
    
    def build_clamp(self, soma):
        clamp = neuron.h.IClamp(soma(0.5))
        clamp.delay = 0
        clamp.dur = 500
        clamp.amp = 0.4
        
        return clamp
    
    def find_label(self, key):
        for recording in self.recording.values():
            if key in recording.keys():
                return recording[key]

        # if key in hoc_labels:
        #     return hoc_labels[key]

        return ''

    def build_records(self, soma):
        records = {}
        location = {'global': neuron.h, 'soma': soma(0.5)}

        for recording in self.recording.keys():
            for parameter in self.recording[recording].keys():
                records[parameter] = neuron.h.Vector()
                records[parameter].record(getattr(location[recording], '_ref_'+parameter))

        return records

    def plot_records(self, title, which):
        to_plot = map(lambda x: np.array(self.records[x]), which)
        plot.plot_line(to_plot, title, map(lambda w: self.find_label(w), which))

    def initialize(self):
        self.records = self.build_records(self.soma)
        
        assign_hoc_globals(self.settings)
        
        neuron.h.dt = self.dt
        neuron.h.finitialize(self.settings['v_init'])
        neuron.init()

    def run(self, duration):
        self.initialize()
        neuron.run(duration)

    def record(self, which, duration):
        self.run(duration)
        return np.array(self.records[which])

    def plot(self):
        self.plot_records('Membrane Voltage (mV)', ('t', 'v'))

# a class to represent a parameter and the range between which it should be varied.
class Parameter:
    def __init__(self, parameter, between):
        self.parameter = parameter
        self.begin, self.end = between

    def series(self, steps):
        return np.linspace(self.begin, self.end, steps)

    def vary(self, model, value):
        base = model
        for part in self.parameter[:-1]:
            base = getattr(base, part)

        setattr(base, self.parameter[-1], value)
        return model

# a class to manage running several trials with a single changing variable over the given range.
class Trials:
    def __init__(self, model, parameters):
        self.model = model
        self.parameters = map(lambda p: Parameter(p[0], (p[1], p[2])), parameters)

    def apply_parameters(self, values):
        for parameter, value in zip(self.parameters, values):
            parameter.vary(self.model, value)
        return self.model

    def series(self, steps):
        return np.transpose(np.vstack(map(lambda p: p.series(steps), self.parameters)))

    def run(self, duration, steps, watch):
        series = self.series(steps)
        Z = np.array(map(lambda ps: self.apply_parameters(ps).record(watch, duration), series))

        timeline = np.array(self.model.records['t'])
        X = np.array(map(lambda y: timeline, series))
        Y = np.array(map(lambda y: map(lambda x: y[0], timeline), series))

        return X, Y, Z
        

# actually run some trials.   -----------------
def vary_parameters(model, parameters, watch, duration, steps, fromzero=False, layered=False):
    trials = Trials(model, parameters)
    X, Y, Z = trials.run(duration, steps, watch)

    ylabel = model.find_label(trials.parameters[0].parameter[-1])
    zlabel = model.find_label(watch)

    if layered:
        plot.plot_layered(X, Y, Z, ylabel, zlabel)
    else:
        plot.plot_series(np.array(trials.model.records['t']), trials.parameters[0].series(steps), Z, ylabel, zlabel, fromzero)

