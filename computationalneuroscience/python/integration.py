from scipy import *
from matplotlib import pyplot as plt

class Variable:
    def __init__(self, label, delta=lambda xi, t: 0, zero=0):
        self.label = label
        self.delta = delta
        self.zero = zero

    def reset(self, system):
        self.level = self.zero
        self.next = self.zero
        setattr(system, self.label, self.level)

    def discern(self, system, dt, t):
        self.next = self.level + (self.delta(system, t) * dt)

    def step(self, system, t):
        self.level = self.next
        setattr(system, self.label, self.level)

class Integration:
    def __init__(self, variables):
        self.variables = variables
        self.figure = plt.figure()

        self.setup()

    def snapshot(self):
        return reduce(lambda snap, var: dict(snap, **{var.label: var.level}), self.variables, {})

    def setup_traces(self):
        self.traces = reduce(lambda traces, key: dict(traces, **{key: []}), self.snapshot().keys(), {})

    def setup(self):
        self.reset()
        self.setup_traces()

    def reset(self):
        for variable in self.variables:
            variable.reset(self)

    def discern(self, dt, t):
        for variable in self.variables:
            variable.discern(self, dt, t)

    def step(self, t):
        for variable in self.variables:
            variable.step(self, t)

    def record(self):
        snap = self.snapshot()
        for key in snap.keys():
            self.traces[key].append(snap[key])

    def run(self, begin, end, step):
        self.setup()
        self.record()

        time = arange(begin, end, step)[1:]
        for t in time:
            self.discern(step, t)
            self.step(t)
            self.record()

    def plot(self, begin, end, step, variables=[], loc="upper right"):
        time = arange(begin, end, step)
        self.run(begin, end, step)

        self.figure.clear()
        for variable in variables:
            plt.plot(time, self.traces[variable])
        plt.legend(variables, loc=loc)




