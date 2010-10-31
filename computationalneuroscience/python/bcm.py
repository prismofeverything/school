import numpy as np
from scipy import *
from matplotlib import pyplot as plt

class BienenstockCooperMunro:
    def __init__(self, tau=(1, 1, 100), size=1000, dt=0.1, vnaught=0.1):
        self.size = size
        self.dt = dt
        self.vnaught = vnaught
        self.figure = plt.figure()

        self.calibrate_tau(tau)
        self.reset()

    def reset(self):
        self.presynaptic = self.poisson() - 1
        self.weights = random.random(self.size) * (1.0 / self.size)
        self.activity = self.vnaught
        self.theta = 0.1
        self.saturation = 1
        self.results = [[], [], []]

        self.cycle_presynaptic()

    def poisson(self):
        return random.poisson(5, self.size)

    def calibrate_tau(self, tau):
        self.tau_r, self.tau_theta, self.tau_w = tau
        self.itau_r, self.itau_theta, self.itau_w = map(lambda x: 1.0 / x, tau)

    def cycle_presynaptic(self):
        self.firing = where(self.presynaptic <= 0, 1, 0)
        self.presynaptic = where(self.presynaptic <= 0, self.poisson() + 1, self.presynaptic) - 1

    def constrain_weights(self):
        self.weights = where(self.weights < 0, 0, self.weights)
        self.weights = where(self.weights > self.saturation, self.saturation, self.weights)

    def dv(self, t):
        return (-self.activity + dot(self.weights, self.firing)) * self.dt * self.itau_r

    def dtheta(self, t):
        return (pow(self.activity, 2) - self.theta) * self.dt * self.itau_theta

    def dw(self, t):
        return (self.activity * self.firing) * (self.activity - self.theta) * self.dt * self.itau_w

    def record(self, t):
        self.results[0].append(self.activity)
        self.results[1].append(self.weights)
        self.results[2].append(self.theta)

    def step(self, t):
        # next_v = self.activity + self.dv(t)
        next_v = dot(self.weights, self.firing)
        next_w = self.weights + self.dw(t)
        next_theta = self.theta + self.dtheta(t)

        if next_v < 0:
            next_v = 0

        self.activity = next_v
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

        self.figure.clear()
        plt.plot(time, v)
        plt.plot(time, map(lambda x: x.sum(), w))
        plt.plot(time, theta)
        plt.legend(('Postsynaptic Activity', 'Total Weights', 'Threshhold'), loc="upper left")




