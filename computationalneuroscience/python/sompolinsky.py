from pylab import *
from IPython.Debugger import Tracer; debug = Tracer()

class Sompolinsky:
    def __init__(self, fields=3, dimensions=3, granularity=4, topology=[[1, 1, 0], [1, 1, 1], [0, 1, 1]], tau=1.0, sigma=1.0, strong=1.0, weak=1.0, order=0.1):
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
        self.N = int(fields * dimensions * granularity)
        self.radius = int(dimensions * granularity)
        self.fields = fields
        self.dimensions = dimensions
        self.granularity = granularity
        self.topology = topology
        self.tau = tau
        self.sigma = sigma
        self.strong = strong / self.N
        self.weak = weak / pow(self.N, 2)
        self.inverseN = 1.0 / self.N
        self.order = order

        self.orientations = self.generate_orientations()
        self.selectivities = self.generate_selectivities()
        self.connectivities = self.generate_connectivities()

        self.reset()

    def reset(self):
        self.stimuli = zeros(self.dimensions)
        self.present = zeros(self.dimensions)
        self.activity = zeros(self.N)

        self.phase = random(self.N) * 2*pi
        self.intrinsic = random(self.N) * self.order
        self.spikes = zeros(self.N)
        self.phases = self.phase

    def insert_granularity(self, dimension):
        """ give a group of neurons corresponding to a particular dimension of stimulus their respective 
            sensitivities"""
        basis = tile(-1.0, [self.dimensions, self.granularity])
        basis[dimension] = self.orientations
        return basis.T

    def generate_orientations(self):
        """ generate even steps around the circle based on the chosen granularity of the sensory response. """
        return linspace(0.0, (self.granularity - 1) * 2*pi / self.granularity, self.granularity)

    def generate_selectivities(self):
        """ each neuron has a preferred orientation.  this function generates those orientations based on 
            the given granularity of the system. 
            stimuli come in as a value between 0 and 2pi.
            -1 represents no selectivity. """
        selectivities = []
        for field in range(self.fields):
            dimensions = map(self.insert_granularity, range(self.dimensions))
            selectivities.append(vstack(dimensions))
        return vstack(selectivities)

    def generate_connectivities(self):
        """ connectivities are strongly coupled between neurons in the same receptive field, and weakly 
            coupled with neurons that correspond to the same feature in other receptive fields. """
        connectivities = zeros([self.N, self.N])
        for field, connections in zip(range(self.fields), self.topology):
            for connection, connectivity in zip(range(self.fields), connections):
                begin = [self.radius * field, self.radius * connection]
                end = [self.radius * (field + 1), self.radius * (connection + 1)]

                if field == connection:
                    connectivities[begin[0]:end[0], begin[1]:end[1]] = tile(self.strong, (self.radius, self.radius))
                elif connectivity == 1:
                    connectivities[begin[0]:end[0], begin[1]:end[1]] = eye(self.radius) * self.weak

        return connectivities

    def tuning(self, field, stimulus):
        """ given a field of selectivities and a stimulus, return a vector composed of that field's 
            responses to the stimulus. """
        return self.V(where(field > 0, field - stimulus, 10000)).sum(axis=1)

    def trigger_activity(self, stimuli):
        """ iterate over the distinct receptive fields with their corresponding stimulus to determine
            the activities of these neurons this time step. """
        self.present = stimuli
        self.responses = []
        for receptive, stimulus in zip(range(self.fields), stimuli):
            field = self.selectivities[(receptive * self.radius):((receptive + 1) * self.radius)]
            self.responses.append(self.tuning(field, stimulus))
        self.activity = hstack(self.responses)
            
    def V(self, thetas):
        return exp(-abs(thetas)) * self.sigma

    def J(self, r):
        return self.activity[r] * self.connectivities[r] * self.activity

    def deltar(self, r):
        return self.intrinsic[r] + sum(self.J(r) * sin(self.phase - self.phase[r]))

    def delta(self):
        return array(map(self.deltar, range(self.N)))

    def step(self, now):
        """ go through a single time step of the system.  now is a vector of size self.dimensions 
            representing the stimulus for this time step. """
        self.stimuli = vstack([self.stimuli, now])
        self.trigger_activity(now)
        self.phase += self.delta()

        self.spikes = vstack([self.spikes, where(self.phase >= 2*pi, 1, 0)])
        self.phase = where(self.phase >= 2*pi, self.phase - (2*pi), self.phase)
        self.phases = vstack([self.phases, self.phase])

    def run(self, steps):
        self.reset()
        for step in steps:
            self.step(step)

