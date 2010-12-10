from pylab import *
from IPython.Debugger import Tracer; debug = Tracer()

class Sompolinsky:
    def __init__(self, fields=3, dimensions=3, granularity=4, topology=[[1, 1, 0], [1, 1, 1], [0, 1, 1]], tau=0.1, strong=0.5, weak=0.1):
        """ Sompolinsky: a general framework for mutually synchronizing interconnected receptive fields.
              fields -- the number of general receptive fields (composed of groups of neurons).
              dimensions -- the number of distinct types of stimuli the system responds to.
              granularity -- how many bins one type of stimuli is divided into.
              topology -- how the fields are connected to one another.  This takes the form of a FIELDSxFIELDS
                matrix showing the connectivity between each field.  The diagonal (self-connection) is always 
                assumed to be 1.
              tau -- the time constant of change
              strong -- the strength of connections within a receptive field
              weak -- the strength of a connection between receptive fields """

        self.N = fields * dimensions * granularity
        self.fields = fields
        self.dimensions = dimensions
        self.granularity = granularity
        self.topology = topology
        self.tau = tau
        self.strong = strong
        self.weak = weak
        self.inverseN = 1.0 / self.N
        self.orientations = linspace(0, (granularity-1) * 2 * pi / granularity, granularity)

        self.generate_selectivities()
        self.generate_connectivities()

        self.reset()

    def insert_granularity(self, dimension):
        basis = tile(-1, [self.dimensions, self.granularity])
        basis[dimension] = self.orientations
        return basis.T

    def generate_selectivities(self):
        """ stimuli come in as a value between 0 and 2pi.
            -1 represents no selectivity. """
        selectivities = []
        for field in range(self.fields):
            dimensions = map(lambda dimension: self.insert_granularity(dimension), range(self.dimensions))
            selectivities.append(vstack(dimensions))
        self.selectivities = vstack(selectivities)

    def generate_connectivities(self):
        connectivities = zeros([self.N, self.N])
        receptive = self.dimensions * self.granularity
        for field, connections in zip(range(self.fields), self.topology):
            for connection, connectivity in zip(range(self.fields), connections):
                begin = [receptive * field, receptive * connection]
                end = [receptive * (field + 1), receptive * (connection + 1)]

                if field == connection:
                    grid = tile(self.strong, (receptive, receptive))
                elif connectivity == 1:
                    grid = eye(receptive) * self.weak
                else:
                    grid = zeros([receptive, receptive])
                
                connectivities[begin[0]:end[0], begin[1]:end[1]] = grid

        self.connectivities = connectivities

    def reset(self):
        self.phase = random(self.N) * 2 * pi
        self.intrinsic = random(self.N)

        self.spikes = zeros(self.N)
        self.phases = self.phase

    def J(self, r, r_):
        self.V(r) * self.W(r, r_) * self.V(r_)

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

