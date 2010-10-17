from itertools import chain

import numpy as np
import neuron

import plot

#load_mechanisms('/Users/rspangler/school/computationalneuroscience/neuron/hh_zoo')
neuron.h.nrn_load_dll('/Users/rspangler/school/computationalneuroscience/neuron/hh_zoo/x86_64/.libs/libnrnmech.so')

def assign_hoc_globals(hoc):
    for key in hoc.keys():
        neuron.h(key + ' = ' + str(hoc[key]))

# the hodgkin-huxley neuron model extended by a transient calcium channel
# and a calcium-gated potassium channel.
class Soma:
    def __init__(self, mechanisms=[], recording={}, settings={}):
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

        default_locations = [('global', 't'), ('soma', 'v')]
        for location, parameter in default_locations:
            if not location in self.recording:
                self.recording[location] = []
            if not parameter in self.recording[location]:
                self.recording[location].append(parameter)
        
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
        clamp.dur = 50
        clamp.amp = 0.4
        
        return clamp
    
    def build_records(self, soma):
        records = {}
        location = {'global': neuron.h, 'soma': soma(0.5)}

        for recording in self.recording.keys():
            for parameter in self.recording[recording]:
                records[parameter] = neuron.h.Vector()
                records[parameter].record(getattr(location[recording], '_ref_'+parameter))

        return records

    def plot_records(self, title, which):
        to_plot = map(lambda x: numpy.array(self.records[x]), which)
        plot.plot_line(to_plot)

    def initialize(self):
        self.records = self.build_records(self.soma)
        
        assign_hoc_globals(self.settings)
        
        neuron.h.dt = 0.025
        neuron.h.finitialize(self.settings['v_init'])

        # neuron init method
        neuron.init()

    def run(self, duration):
        self.initialize()
        neuron.run(duration)

    def record(self, which, duration):
        self.run(duration)
        return np.array(self.records[which])

    def volts(self, duration):
        run(duration)
        return np.array(self.records['v'])

    def time(self):
        return np.array(self.records['t'])

    def voltage(self):
        return np.array(self.records['v'])

    def plot(self):
        self.plot_records('Membrane Voltage', ['t', 'v'])

# a class to represent a parameter and the range between which it should be varied.
class Parameter:
    def __init__(self, parameter, between, label=''):
        self.parameter = parameter
        self.begin, self.end = between
        self.label = label

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
        self.parameters = map(lambda p: Parameter(p[1], (p[2], p[3]), p[0]), parameters)

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
def vary_parameters(model, parameters, watch, duration, steps, reverse=False, layered=False):
    trials = Trials(model, parameters)
    X, Y, Z = trials.run(duration, steps, watch)

    if reverse:
        Z = list(Z)
        Z.reverse()
        Z = np.array(Z)

    label = trials.parameters[0].label
    if layered:
        plot.plot_layered(X, Y, Z, label)
    else:
        plot.plot_series(np.array(trials.model.records['t']), trials.parameters[0].series(steps), Z, label)


# specific change functions.  Each one is called with a beginning and ending value for that parameter 
# and how many steps in the series of trials.

# sodium reversal potential
def change_ena(duration, begin, end, steps):
    soma = Soma(['hh', 'cadyn'])
    vary_parameters(soma, [('Na Reversal Potential (mV)', ('soma', 'ena'), begin, end)], 'v', duration, steps)

# stimulus amplitude
def change_clamp(duration, begin, end, steps):
    soma = Soma(['hh', 'cadyn'])
    vary_parameters(soma, [('Stimulus Amplitude (nA)', ('clamp', 'amp'), begin, end)], 'v', duration, steps)

# membrane potential
def change_vinit(begin, end, steps):
    def change(simple, value):
        simple.soma.v = value
        simple.soma.gkbar_hh = 0
        simple.soma.gl_hh = 0
        return simple

    run_trials(np.linspace(begin, end, steps), change, 'Membrane Potential (mV)')

# sodium conductance
def change_gna(begin, end, steps):
    def change(simple, value):
        simple.soma.gnabar_hh = value
        return simple

    run_trials(np.linspace(begin, end, steps), change, 'Na Conductance (S/cm^2)')

# potassium conductance
def change_gk(begin, end, steps):
    def change(simple, value):
        simple.soma.gkbar_hh = value
        return simple

    run_trials(np.linspace(begin, end, steps), change, '0.08 - K Conductance (S/cm^2)', True)

# potassium conductance
def change_gkca(begin, end, steps):
    def change(simple, value):
        simple.soma.pcabar_iT = (value / 70)
        simple.soma.gkbar_iC = value
        return simple

    run_trials(np.linspace(begin, end, steps), change, 'K(Ca) Conductance (S/cm^2)', True)

