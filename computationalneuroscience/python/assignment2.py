import numpy as np
from itertools import chain
from neuron import *

import plot

#load_mechanisms('/Users/rspangler/school/computationalneuroscience/neuron/hh_zoo')
h.nrn_load_dll('/Users/rspangler/school/computationalneuroscience/neuron/hh_zoo/x86_64/.libs/libnrnmech.so')

def assign_hoc_globals(hoc):
    for key in hoc.keys():
        h(key + ' = ' + str(hoc[key]))

# the hodgkin-huxley neuron model extended by a transient calcium channel
# and a calcium-gated potassium channel.
class ExtendedHH:
    def __init__(self):
        self.duration = 50
        self.settings = {
            'celsius': 15,
            'v_init': -70,
            'g_passive': .0003,
            'erev_passive': -70,
            'gnaHH': .12,
            'gkHH': .036,
            'glHH': .0003
        }

    def build_soma(self):
        soma = h.Section()
        soma.nseg = 1
        soma.diam = 20
        soma.L = 20
        soma.Ra = 100
        soma.insert('hh')
        soma.insert('cadyn')
        soma.insert('iT')
        soma.insert('iC')
        
        return soma
    
    def build_clamp(self, soma):
        clamp = h.IClamp(soma(0.5))
        clamp.delay = 0
        clamp.dur = 50
        clamp.amp = 0.4
        
        return clamp
    
    def build_records(self, soma):
        records = {}
        records['time'] = h.Vector()
        records['time'].record(h._ref_t)
        records['voltage'] = h.Vector()
        records['voltage'].record(soma(0.5)._ref_v)
        records['calcium_current'] = h.Vector()
        records['calcium_current'].record(soma(0.5)._ref_gkbar_iC)

        return records

    def plot_records(self, title, which):
        to_plot = map(lambda x: numpy.array(self.records[x]), which)
        plot.plot_line(to_plot)

    def initialize(self):
        assign_hoc_globals(self.settings)
        
        self.soma = self.build_soma()
        self.clamp = self.build_clamp(self.soma)
        self.records = self.build_records(self.soma)
        
        h.dt = 0.025
        h.finitialize(self.settings['v_init'])
        init()

    def go(self):
        run(self.initialize().duration)

    def base(self):
        self.initialize()
        return self

    def volts(self):
        run(self.duration)
        return np.array(self.records['voltage'])

    def time(self):
        return self.records['time']

    def voltage(self):
        return self.records['voltage']

    def plot(self):
        self.plot_records('Membrane Voltage', ['time', 'voltage'])

# a class to manage running several trials with a single changing variable over the given range.
class Trials:
    def __init__(self, model, trials, change):
        self.trials = trials
        self.change = change

        if not self.change:
            def change(soma, value):
                return soma
            self.change = change

        self.model = model

    def run(self):
        Z = map(lambda x: self.change(self.model.base(), x).volts(), self.trials)

        timeline = np.array(self.model.records['time'])
        X = np.array(map(lambda y: timeline, self.trials))
        Y = np.array(map(lambda y: map(lambda x: y, timeline), self.trials))

        return X, Y, np.array(Z)
        

# actually run some trials.   -----------------
# steps is an array containing the series of values for the changing parameter.
# change is a function which given a SimpleHH object transforms it in a way specific to the particular 
# experiment being run.  
# reverse, if True, will reverse the sequence of trials.
# layered determines whether the resulting graph is a parametric surface or a series of trials.
def run_trials(steps, change, variable, reverse=False, layered=False):
    trials = Trials(ExtendedHH(), steps, change)
    X, Y, Z = trials.run()
    if reverse:
        Z = list(Z)
        Z.reverse()
        Z = np.array(Z)

    if layered:
        plot.plot_layered(X, Y, Z, variable)
    else:
        plot.plot_series(np.array(trials.model.records['time']), steps, Z, variable)



# specific change functions.  Each one is called with a beginning and ending value for that parameter 
# and how many steps in the series of trials.

# sodium reversal potential
def change_ena(begin, end, steps):
    def change(simple, value):
        simple.soma.ena = value
        return simple

    run_trials(np.linspace(begin, end, steps), change, 'Na Reversal Potential (mV)')

# stimulus amplitude
def change_clamp(begin, end, steps):
    def change(simple, value):
        simple.clamp.amp = value
        return simple

    run_trials(np.linspace(begin, end, steps), change, 'Stimulus Amplitude (nA)')

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


# example -----------------------

# run a series of trials where the stimulus amplitude varies from 0.0 to 0.4 over 20 steps.

# > change_clamp(0.0, 0.4, 20)  
