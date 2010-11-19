from IPython.Debugger import Tracer; debug = Tracer()

from math import exp
import numpy as np
from scipy import *
from matplotlib import pyplot as plt

class Integration:
    def __init__(self, dt=1):
        self.dt = dt
        self.figure = plt.figure()

        self.reset()

    def snapshot(self):
        return {} 

    def setup_traces(self):
        self.traces = reduce(lambda traces, key: dict(traces, **{key: []}), self.snapshot().keys(), {})        

    def reset(self):
        self.setup_traces()

    def discern(self, t):
        pass

    def step(self, t):
        pass

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
            self.step(t)
            self.record()

    def plot(self, begin, end, step, variables=[], loc="upper right"):
        time = arange(begin, end, step)
        self.run(begin, end, step)

        self.figure.clear()
        for variable in variables:
            plt.plot(time, self.traces[variable])
        plt.legend(variables, loc=loc)




