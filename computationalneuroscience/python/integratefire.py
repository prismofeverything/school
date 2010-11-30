from IPython.Debugger import Tracer; debug = Tracer()

from integration import *
from matplotlib import pyplot as plt

class IntegrateFire(Integration):
    def __init__(self, dt=1, resistance=10.0, tau=10.0, threshhold=5.0, spike=70.0, base=0, leak=0.0, amp=1.0, on=10, dur=50, span=100):
        self.resistance = resistance
        self.tau = tau
        self.threshhold = threshhold
        self.spike = spike
        self.base = base
        self.leak = leak
        self.amp = amp
        self.on = on
        self.dur = dur
        self.span = span

        self.Vvar = Variable('V', lambda xi, t: xi.V_next(t) - xi.V, self.base)

        Integration.__init__(self, [self.Vvar])

    def current(self, t):
        if t >= self.on and t < (self.on + self.dur):
            return self.amp
        else:
            return 0

    def delta(self, t):
        return (self.leak - self.V + (self.resistance * self.current(t))) / self.tau

    def V_next(self, t):
        if self.V == self.spike:
            return self.base
        elif self.V > self.threshhold:
            self.spikes += 1
            return self.spike
        else:
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
