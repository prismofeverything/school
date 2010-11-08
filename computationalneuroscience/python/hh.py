from IPython.Debugger import Tracer; debug = Tracer()

from math import exp
import numpy as np
from scipy import *
from matplotlib import pyplot as plt

class Gate:
    def __init__(self, level=0, power=1, alpha=lambda x: 0, beta=lambda x: 0):
        self.levelinit = level
        self.level = level
        self.power = power
        self.alpha = alpha
        self.beta = beta

        self.level_delta = 0

    def gate(self):
        return pow(self.level, self.power)

    def delta(self, V, t):
        return (self.alpha(V) * (1.0 - self.level)) - (self.beta(V) * self.level)

    def discern(self, V, t):
        self.level_delta = self.delta(V, t)

    def step(self, dt):
        self.level = self.level + (self.level_delta * dt)

    def reset(self):
        self.level = self.levelinit
        self.level_delta = 0

class Current:
    def __init__(self, reversal=0, conductance=1, gates=[]):
        self.reversal = reversal
        self.conductance = conductance
        self.amplitude = 0
        self.gates = gates
        
        if len(self.gates) == 0:
            self.gates = [Gate(level=1)]

    def gate(self):
        return reduce(lambda g, y: g * y.gate(), self.gates, 1)

    def delta(self, V, t):
        self.amplitude = -self.conductance * self.gate() * (V - self.reversal)
        return self.amplitude

    def discern(self, V, t):
        for gate in self.gates:
            gate.discern(V, t)

    def step(self, dt):
        for gate in self.gates:
            gate.step(dt)

    def reset(self):
        for gate in self.gates:
            gate.reset()

class Stimulus:
    def __init__(self, begin, end, amp):
        self.begin = begin
        self.end = end
        self.amp = amp
        self.area = 1.26e-2

    def delta(self, V, t):
        if t >= self.begin and t <= self.end:
            return self.amp / self.area
        else:
            return 0

    def discern(self, V, t):
        pass

    def step(self, dt):
        pass

    def reset(self):
        pass

class HodgkinHuxley:
    def __init__(self, dt=0.1, vinit = -65):
        self.dt = dt
        self.vinit = vinit
        self.voltage_delta = 0

        self.m = Gate(level = 0.053, power = 3, 
                      alpha = lambda V: (0.1 * (V + 40)) / (1 - exp(-0.1 * (V + 40))),
                      beta  = lambda V: 4 * exp(-0.0556 * (V + 65)))

        self.h = Gate(level = 0.595, power = 1, 
                      alpha = lambda V: 0.07 * exp(-0.05 * (V + 65)),
                      beta  = lambda V: 1.0 / (1 + exp(-0.1 * (V + 35))))

        self.n = Gate(level = 0.318, power = 4,
                      alpha = lambda V: (0.01 * (V + 55)) / (1 - exp(-0.1 * (V + 55))),
                      beta  = lambda V: 0.125 * exp(-0.0125 * (V + 65)))

        self.na   = Current(reversal=50,    conductance=120, gates=[self.m, self.h])
        self.k    = Current(reversal=-77,   conductance=36,  gates=[self.n])
        self.leak = Current(reversal=-54.4, conductance=0.3)
        self.stimulus = Stimulus(5, 6, 0.1)

        self.currents = [self.na, self.k, self.leak, self.stimulus]
        self.reset()

    def reset(self):
        self.voltage = self.vinit
        self.voltage_delta = 0
        self.traces = {'V': [], 'ina': [], 'ik': [], 'ileak': [], 'm': [], 'h': [], 'n': []}
        self.figure = plt.figure()

        for current in self.currents:
            current.reset()

    def dvoltage(self, t):
        return reduce(lambda v, current: v + current.delta(self.voltage, t), self.currents, 0)

    def discern(self, t):
        self.voltage_delta = self.dvoltage(t)
        for current in self.currents:
            current.discern(self.voltage, t)

    def step(self):
        self.voltage = self.voltage + (self.voltage_delta * self.dt)
        for current in self.currents:
            current.step(self.dt)

    def snapshot(self):
        return {'V': self.voltage, 
                'ina': self.na.amplitude, 
                'ik': self.k.amplitude, 
                'ileak': self.leak.amplitude, 
                'm': self.m.level, 
                'h': self.h.level, 
                'n': self.n.level}

    def record(self):
        snap = self.snapshot()
        for key in snap.keys():
            self.traces[key].append(snap[key])

    def run(self, begin, end, step):
        self.reset()
        self.record()

        self.dt = step
        time = arange(begin, end, step)[1:]
        for t in time:
            self.discern(t)
            self.step()
            self.record()

    def plot(self, begin, end, step, variables=['V']):
        time = arange(begin, end, step)
        self.run(begin, end, step)

        self.figure.clear()
        for variable in variables:
            plt.plot(time, self.traces[variable])
        plt.legend(variables, loc="upper right")


