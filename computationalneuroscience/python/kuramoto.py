from pylab import *
tau = 2 * pi

class Kuramoto:
    def __init__(self, N, K=0.1, order=0.1):
        self.N = N
        self.K = K
        self.order = order
        self.scale = K / N

        self.reset()

    def reset(self):
        self.phase = random(self.N) * tau
        self.intrinsic = random(self.N) * self.order

        self.spikes = zeros(self.N)
        self.phases = self.phase

    def deltax(self, x):
        differences = sum(sin(self.phase - self.phase[x]))
        return self.intrinsic[x] + self.scale * differences

    def delta(self):
        return array(map(lambda x: self.deltax(x), range(self.N)))

    def step(self):
        self.phase += self.delta()
        spiking = (self.phase >= tau)
        self.spikes = vstack([self.spikes, where(spiking, 1, 0)])
        self.phase = where(spiking, self.phase - tau, self.phase)
        self.phases = vstack([self.phases, self.phase])

    def run(self, steps):
        self.reset()
        for step in range(steps):
            self.step()



