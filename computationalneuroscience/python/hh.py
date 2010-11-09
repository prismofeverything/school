from IPython.Debugger import Tracer; debug = Tracer()

from math import exp
import numpy as np
from scipy import *
from matplotlib import pyplot as plt

class Gate:
    def __init__(self, level=0, power=1, alpha=lambda x: 0, beta=lambda x: 0, inf=None, tau=None):
        self.levelinit = level
        self.level = level
        self.power = power
        self.alpha = alpha
        self.beta = beta
        self.inf = inf
        self.tau = tau

        self.level_delta = 0

    def gate(self):
        return pow(self.level, self.power)

    def delta(self, soma, t):
        if self.inf and self.tau:
            self.level_delta = (self.inf(soma) - self.level) / self.tau(soma)
        else:
            self.level_delta = (self.alpha(soma) * (1.0 - self.level)) - (self.beta(soma) * self.level)            
        return self.level_delta

    def discern(self, soma, t):
        self.level_delta = self.delta(soma, t)

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

    def delta(self, soma, t):
        self.amplitude = -self.conductance * self.gate() * (soma.voltage - self.reversal)
        return self.amplitude

    def discern(self, soma, t):
        for gate in self.gates:
            gate.discern(soma, t)

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

    def delta(self, soma, t):
        if t >= self.begin and t <= self.end:
            return self.amp / self.area
        else:
            return 0

    def discern(self, soma, t):
        pass

    def step(self, dt):
        pass

    def reset(self):
        pass

class HodgkinHuxley:
    def __init__(self, dt=0.1, vinit = -65, tau_calcium = 0.03):
        self.dt = dt
        self.vinit = vinit
        self.tau_calcium = tau_calcium

        # sodium activation
        self.m = Gate(level = 0.053, power = 3, 
                      alpha = lambda soma: (0.1 * (soma.voltage + 40)) / (1 - exp(-0.1 * (soma.voltage + 40))),
                      beta  = lambda soma: 4 * exp(-0.0556 * (soma.voltage + 65)))

        # sodium inactivation
        self.h = Gate(level = 0.595, power = 1, 
                      alpha = lambda soma: 0.07 * exp(-0.05 * (soma.voltage + 65)),
                      beta  = lambda soma: 1.0 / (1 + exp(-0.1 * (soma.voltage + 35))))

        # potassium activation
        self.n = Gate(level = 0.318, power = 4,
                      alpha = lambda soma: (0.01 * (soma.voltage + 55)) / (1 - exp(-0.1 * (soma.voltage + 55))),
                      beta  = lambda soma: 0.125 * exp(-0.0125 * (soma.voltage + 65)))

        # calcium-gated potassium activation
        self.c = Gate(level = 0.1,   power = 4,
                      inf   = lambda soma: (soma.calcium / (soma.calcium + 3)) * (1.0 / (1 + exp(-(soma.voltage + 28.3) / 12.6))),
                      tau   = lambda soma: 90.3 - (75.1 / (1 + exp(-(soma.voltage + 46) / 22.7))))

        # transient calcium activation
        self.l = Gate(level = 0.48,  power = 2,
                      inf   = lambda soma: 1.0 / (1 + exp(-(soma.voltage + 57) / 62)),
                      tau   = lambda soma: 0.612 + 1.0 / (exp(-(soma.voltage + 132) / 16.7) + exp((soma.voltage + 16.8) / 18.2)))

        # transient calcium inactivation
        self.g = Gate(level = 0.65,  power = 1,
                      inf   = lambda soma: 1.0 / (1 + exp((soma.voltage + 81) / 4)),
                      tau   = lambda soma: exp((soma.voltage + 467) / 66.6) if soma.voltage < -80 else 28 + exp(-(soma.voltage + 22) / 10.5))

        self.na   = Current(reversal = 50,    conductance = 120, gates = [self.m, self.h])
        self.k    = Current(reversal = -77,   conductance = 36,  gates = [self.n])
        self.kca  = Current(reversal = -77,   conductance = 36,   gates = [self.c])
        self.cat  = Current(reversal = 120,   conductance = 1.3,  gates = [self.l, self.g])

        self.leak = Current(reversal = -54.4, conductance = 0.3)
        self.stimulus = Stimulus(5, 6, 0.1)
        self.hyper = Stimulus(80, 90, -0.2)

        # self.currents = [self.na, self.k, self.leak, self.stimulus]
        # self.currents = [self.na, self.k, self.leak, self.kca, self.cat, self.hyper]
        self.currents = [self.na, self.k, self.leak, self.kca, self.cat]
        self.reset()

    def reset(self):
        self.voltage = self.vinit
        self.voltage_delta = 0
        self.calcium = 0
        self.calcium_delta = 0

        self.traces = reduce(lambda traces, key: dict(traces, **{key: []}), self.snapshot().keys(), {})
        self.figure = plt.figure()

        for current in self.currents:
            current.reset()

    def dvoltage(self, t):
        return reduce(lambda v, current: v + current.delta(self, t), self.currents, 0)

    def dcalcium(self, t):
        return (self.cat.amplitude * 0.2) - (self.calcium * self.tau_calcium)

    def discern(self, t):
        self.voltage_delta = self.dvoltage(t)
        self.calcium_delta = self.dcalcium(t)

        for current in self.currents:
            current.discern(self, t)

    def step(self):
        self.voltage = self.voltage + (self.voltage_delta * self.dt)
        self.calcium = self.calcium + (self.calcium_delta * self.dt)

        for current in self.currents:
            current.step(self.dt)

    def snapshot(self):
        return {'V': self.voltage, 
                'ca': self.calcium,
                'ina': self.na.amplitude, 
                'ik': self.k.amplitude, 
                'ileak': self.leak.amplitude, 
                'ikca': self.kca.amplitude,
                'icat': self.cat.amplitude,
                'm': self.m.level, 
                'h': self.h.level, 
                'n': self.n.level,
                'c': self.c.level,
                'l': self.l.level,
                'g': self.g.level}

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


