from pylab import *

class Sompolinsky:
    def __init__(self, fields=2, dimensions=3, granularity=4, tau=0.1):
        self.N = fields * dimensions * granularity
        self.fields = fields
        self.dimensions = dimensions
        self.granularity = granularity
        self.tau = tau
        self.inverseN = 1.0 / self.N
        self.orientations = linspace(0, (granularity-1) * 2 * pi / granularity, granularity)

        selectivities = []
        for field in range(self.fields):
            dimensions = map(lambda dimension: self.insert_granularity(dimension), range(self.dimensions))
            selectivities.append(vstack(dimensions))
        self.selectivities = vstack(selectivities)

        self.reset()

    def insert_granularity(self, dimension):
        basis = zeros([self.dimensions, self.granularity])
        basis[dimension] = self.orientations
        return basis.T

    def reset(self):
        self.phase = random(self.N) * 2 * pi
        self.intrinsic = random(self.N)

        self.spikes = zeros(self.N)
        self.phases = self.phase

    def J(self, r, r_):
        self.V(r)

    def deltax(self, x):
        return self.intrinsic[x] + self.K * self.inverseN * sum(sin(self.phase - self.phase[x]))

    def delta(self):
        return array(map(lambda x: self.deltax(x), range(self.N)))

    def step(self):
        self.phase += self.delta()
        self.spikes = vstack([self.spikes, where(self.phase >= 2 * pi, 1, 0)])
        self.phase = where(self.phase >= tau, self.phase - (2 * pi), self.phase)
        self.phases = vstack([self.phases, self.phase])

    def run(self, steps):
        self.reset()
        for step in range(steps):
            self.step()

