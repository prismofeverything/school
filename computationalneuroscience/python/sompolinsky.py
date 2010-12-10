from pylab import *
from IPython.Debugger import Tracer; debug = Tracer()

class Sompolinsky:
    def __init__(self, fields=3, dimensions=3, granularity=4, topology=[[1, 1, 0], [1, 1, 1], [0, 1, 1]], tau=0.1, sigma=1.0, strong=1.0, weak=1.0, base=0.04, order=0.01):
        """ Sompolinsky: a general framework for mutually synchronizing interconnected receptive fields.
              fields -- the number of general receptive fields (composed of groups of neurons).
              dimensions -- the number of distinct types of stimuli the system responds to.
              granularity -- how many bins one type of stimuli is divided into.
              topology -- how the fields are connected to one another.  This takes the form of a FIELDSxFIELDS
                matrix showing the connectivity between each field.  The diagonal (self-connection) is always 
                assumed to be 1.
              tau -- the time constant of change
              sigma -- the rate of intolerance to other stimulus orientations
              strong -- the strength of connections within a receptive field
              weak -- the strength of a connection between receptive fields 
              base -- the minimum frequency 
              order -- the span of frequency values """
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
        self.base = base
        self.order = order

        self.orientations = self.generate_orientations()
        self.selectivities = self.generate_selectivities()
        self.connectivities = self.generate_connectivities()

        self.reset()

    def reset(self):
        """ restore the model to its initial conditions. """
        self.stimuli = zeros(self.dimensions)
        self.present = zeros(self.dimensions)
        self.activity = zeros(self.N)

        self.phase = random(self.N) * 2*pi
        self.intrinsic = random(self.N) * self.order + self.base
        self.spikes = zeros(self.N)
        self.phases = self.phase

    def insert_granularity(self, dimension):
        """ give a group of neurons corresponding to a particular dimension of stimulus their respective 
            sensitivities. """
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
        return self.V(mod(where(field >= 0, field - stimulus, 10000), 2*pi)).sum(axis=1)

    def trigger_activity(self, stimuli):
        """ iterate over the distinct receptive fields with their corresponding stimulus to determine
            the activities of these neurons this time step. """
        self.present = stimuli
        responses = []
        for receptive, stimulus in zip(range(self.fields), stimuli):
            field = self.selectivities[(receptive * self.radius):((receptive + 1) * self.radius)]
            responses.append(self.tuning(field, stimulus))
        return hstack(responses)
            
    def V(self, thetas):
        """ the tuning curve for the selectivity of a neuron """
        return exp(-abs(thetas)) * self.sigma

    def J(self, r):
        """ the connectivity function """
        return self.activity[r] * self.connectivities[r] * self.activity

    def noise(self, size, width=0.1):
        return random(size) * width - (width * 0.5)

    def deltar(self, r):
        """ the change in phase for a single neuron. """
        return self.intrinsic[r] + sum(self.J(r) * sin(self.phase - self.phase[r])) * self.tau

    def delta(self):
        """ the phase function for all neurons in the system. """
        return array(map(self.deltar, range(self.N)))

    def step(self, now):
        """ go through a single time step of the system.  now is a vector of size self.dimensions 
            representing the stimulus for this time step. """
        self.stimuli = vstack([self.stimuli, now])
        self.activity = self.trigger_activity(now)
        self.phase += self.delta()

        self.spikes = vstack([self.spikes, where(self.phase >= 2*pi, 1, 0)])
        self.phase = where(self.phase >= 2*pi, self.phase - (2*pi), self.phase)
        self.phases = vstack([self.phases, self.phase])

    def run(self, steps):
        """ run the simulation for the given stream of stimuli.  
            steps must be a list of vectors for each field each of which has the same size as the model's dimension. """
        self.reset()
        for step in steps:
            self.step(step)

