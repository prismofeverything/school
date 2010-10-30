import numpy as np
from scipy import *
from matplotlib import pyplot as plt

class BienenstockCooperMunro:
    def __init__(self, tau=(100, 1000, 1000000), constraining=False, size=1000, dt=0.1, vnaught=1):
        self.size = size
        self.dt = dt
        self.vnaught = vnaught

        self.calibrate_tau(tau)
        self.constraining = constraining
        self.reset()

    def reset(self):
        self.presynaptic = self.poisson()
        self.weights = random.random(self.size) * (1.0 / self.size)
        self.postsynaptic = self.vnaught
        self.theta = 1
        self.saturation = 1
        self.results = [[], [], []]

        self.cycle_presynaptic()

    def poisson(self):
        return random.poisson(5, self.size)

    def calibrate_tau(self, tau):
        self.tau_r, self.tau_theta, self.tau_w = tau

    def cycle_presynaptic(self):
        self.firing = where(self.presynaptic <= 0, 1, 0)
        self.presynaptic = where(self.presynaptic <= 0, self.poisson(), self.presynaptic) - 1

        print self.firing[:20]
        print self.presynaptic[:20]

    def constrain_weights(self):
        self.weights = where(self.weights < 0, 0, self.weights)
        self.weights = where(self.weights > self.saturation, self.saturation, self.weights)

    def dv(self, t):
        return (-self.postsynaptic + dot(self.weights, self.firing)) * self.dt / self.tau_r

    def dtheta(self, t):
        if self.constraining:
            return 0
        else:
            return (pow(self.postsynaptic, 2) - self.theta) * self.dt / self.tau_theta

    def dw(self, t):
        return (self.postsynaptic * self.firing) * (self.postsynaptic - self.theta) * self.dt / self.tau_w

    def record(self, t):
        self.results[0].append(self.postsynaptic)
        self.results[1].append(self.weights)
        self.results[2].append(self.theta)

    def step(self, t):
        # next_v = self.postsynaptic + self.dv(t)
        next_v = dot(self.weights, self.firing)
        next_w = self.weights + self.dw(t)
        next_theta = self.theta + self.dtheta(t)

        if next_v < 0:
            next_v = 0

        self.postsynaptic = next_v
        self.weights = next_w
        self.theta = next_theta

        self.cycle_presynaptic()
        self.constrain_weights()

        self.record(t)

    def run(self, begin, end, step):
        self.reset()
        self.record(begin)

        self.dt = step
        time = arange(begin, end, step)[1:]
        for t in time:
            self.step(t)

        return self.results

    def plot(self, begin, end, step):
        time = arange(begin, end, step)
        v, w, theta = self.run(begin, end, step)

        plt.plot(time, v)
        plt.plot(time, map(lambda x: x.sum(), w))
        plt.plot(time, theta)
        plt.legend(('Postsynaptic Activity', 'Total Weights', 'Threshhold'), loc="lower left")
