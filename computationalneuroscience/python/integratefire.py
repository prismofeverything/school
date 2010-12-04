from IPython.Debugger import Tracer; debug = Tracer()

from integration import *
from matplotlib import pyplot as plt

class IntegrateFire(Integration):
    def __init__(self, dt=1, resistance=10.0, tau=10.0, taursa=1.0, rofm=1.0, kreversal=0.0, threshhold=5.0, spike=70.0, base=0, leak=0.0, amp=1.0, on=10, dur=90, span=100, deltagrsa=1.0):
        self.resistance = resistance
        self.tau = tau
        self.taursa = taursa
        self.kreversal = kreversal
        self.rofm = rofm
        self.threshhold = threshhold
        self.spike = spike
        self.deltagrsa = deltagrsa
        self.base = base
        self.leak = leak
        self.amp = amp
        self.on = on
        self.dur = dur
        self.span = span

        self.Vvar = Variable('V', lambda xi, t: xi.V_next(t) - xi.V, self.base)
        self.grsavar = Variable('grsa', lambda xi, t: 0 if xi.spiking else -xi.grsa / xi.taursa)

        self.spiking = False

        Integration.__init__(self, [self.Vvar, self.grsavar])

    def current(self, t):
        if t >= self.on and t < (self.on + self.dur):
            return self.amp
        else:
            return 0

    def potassium(self):
        return self.rofm * self.grsa * (self.V - self.kreversal)

    def delta(self, t):
        return (self.leak - self.V - self.potassium() + (self.resistance * self.current(t))) / self.tau

    def V_next(self, t):
        if self.V == self.spike:
            self.spiking = False
            return self.base
        elif self.V > self.threshhold:
            self.spiking = True
            self.spikes += 1
            self.grsavar.level += self.deltagrsa
            return self.spike
        else:
            self.spiking = False
            return self.V + self.delta(t)

    def reset(self):
        self.spikes = 0
        Integration.reset(self)

class Trials:
    def __init__(self, dt=0.1):
        self.dt = dt
        self.span = 1000
        self.on = 0
        self.dur = 1000
        self.fire = IntegrateFire(dt=self.dt, span=self.span, on=self.on, dur=self.dur)

    def run(self, begin, end, step):
        self.spikes = []
        self.amps = arange(begin, end, step)
        for amp in self.amps:
            self.fire.reset()
            self.fire.amp = amp
            self.fire.run(self.on, self.dur, self.dt)
            self.spikes.append(self.fire.spikes)

        plt.plot(self.amps, self.spikes)
        plt.legend(['Firing Rate (Hz) vs Stimulus Amplitude (nA)'], loc='bottom right')
