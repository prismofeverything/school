import numpy as np

from mpl_toolkits.mplot3d import axes3d

from matplotlib import cm
from matplotlib.collections import PolyCollection
from matplotlib import pyplot as plt

from itertools import chain
from neuron import *

def assign_hoc_globals(hoc):
    for key in hoc.keys():
        h(key + ' = ' + str(hoc[key]))

# return the X and Y matrices of a parametric surface 
# that corresponds to the shape of a given Z matrix.
def xy3d(Z):
    xs = range(0, Z.shape[1])
    ys = range(0, Z.shape[0])
    X = np.array(map(lambda y: xs, ys))
    Y = np.array(map(lambda y: map(lambda x: y, xs), ys))

    return X, Y

# plotting a parametric surface.
def plot_layered(X, Y, Z, variable='X'):
    figure = plt.figure()
    ax = figure.add_subplot(111, projection='3d')
    ax.plot_surface(X, Y, Z, rstride=2, cstride=2, cmap=cm.jet)
    ax.set_xlabel('Time (ms)')
    ax.set_ylabel(variable)
    ax.set_zlabel('Voltage (mV)')
    
# plot the data as a series of trials.
def plot_series(time, variable, series, name='X'):
    minimum = -80
    figure = plt.figure()
    ax = figure.gca(projection='3d')

    def stub(tri):
        trial = map(lambda x: x - minimum, np.array(tri))
        trial[0] = 0
        trial[-1] = 0
        return trial

    verts = map(lambda trial: zip(time, stub(trial)), series)

    poly = PolyCollection(np.array(verts), facecolors=map(lambda n: cm.jet(n), np.linspace(0, 1, len(series))))
    poly.set_alpha(0.7)

    ax.add_collection3d(poly, zs=variable, zdir='y')
    ax.set_xlim3d(time[0], time[-1])
    ax.set_ylim3d(variable[0], variable[-1])
    ax.set_zlim3d(0, 80 - minimum)

    ax.set_xlabel('Time (ms)')
    ax.set_ylabel(name)
    ax.set_zlabel('Voltage + 80 (mV)')

# a basic class for the hodgkin-huxley neuron model.
class SimpleHH:
    def __init__(self):
        self.duration = 1
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
        
        return soma
    
    def build_clamp(self, soma):
        clamp = h.IClamp(soma(0.5))
        clamp.delay = 0
        clamp.dur = 1
        clamp.amp = 0.4
        
        return clamp
    
    def build_records(self, soma):
        records = {}
        records['time'] = h.Vector()
        records['time'].record(h._ref_t)
        records['voltage'] = h.Vector()
        records['voltage'].record(soma(0.5)._ref_v)

        return records

    def plot_records(self, title, which):
        to_plot = map(lambda x: numpy.array(self.records[x]), which)

        plt.plot(to_plot[0], to_plot[1])
        plt.title(title)
        plt.xlabel(which[0])
        plt.ylabel(which[1])
        plt.axis(ymin=-120, ymax=120)

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
class HHTrials:
    def __init__(self, trials, change):
        self.trials = trials
        self.change = change

        if not self.change:
            def change(soma, value):
                return soma
            self.change = change

        self.hh = SimpleHH()

    def run(self):
        Z = map(lambda x: self.change(self.hh.base(), x).volts(), self.trials)

        timeline = np.array(self.hh.records['time'])
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
    trials = HHTrials(steps, change)
    X, Y, Z = trials.run()
    if reverse:
        Z = list(Z)
        Z.reverse()
        Z = np.array(Z)

    if layered:
        plot_layered(X, Y, Z, variable)
    else:
        plot_series(np.array(trials.hh.records['time']), steps, Z, variable)



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


# example -----------------------

# run a series of trials where the stimulus amplitude varies from 0.0 to 0.4 over 20 steps.

# > change_clamp(0.0, 0.4, 20)  
