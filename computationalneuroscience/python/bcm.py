import numpy as np
from scipy import *
from matplotlib import pyplot as plt

def constrain(vector, bound):
    def c(x):
        return np.min([np.max([x, -bound]), bound])
    return array(map(c, vector))

class BienenstockCooperMunro:
    def __init__(self, tau=(100, 1000, 1000000), constraining=False, size=1000, dt=0.1, vnaught=1):
        self.size = size
        self.dt = dt
        self.vnaught = vnaught

        self.calibrate_tau(tau)
        self.constraining = constraining
        self.reset()

    def reset(self):
        self.postsynaptic = self.vnaught
        self.weights = (random.random(self.size)*2) - 1
        self.presynaptic = random.poisson(5, self.size) # self.presynaptic_activity(0)
        self.theta = 1
        self.saturation = 1
        self.results = [[], [], []]

    def presynaptic_activity(self, t):
        return self.presynaptic
#        return random.poisson(5, self.size)

    def calibrate_tau(self, tau):
        self.tau_r, self.tau_theta, self.tau_w = tau

    def dv_full(self, t):
        return (-self.postsynaptic + dot(self.weights, self.presynaptic)) * self.dt / self.tau_r

    def dv(self, t):
        return dot(self.weights, self.presynaptic) * self.dt / self.tau_r

    def dtheta(self, t):
        if self.constraining:
            return 0
        else:
            return (pow(self.postsynaptic, 2) - self.theta) * self.dt / self.tau_theta

    def dw(self, t):
        return (self.postsynaptic * self.presynaptic) * (self.postsynaptic - self.theta) * self.dt / self.tau_w

    def constrain_weights(self):
        self.weights = constrain(self.weights, self.saturation)
            
    def record(self, t):
        self.results[0].append(self.postsynaptic)
        self.results[1].append(self.weights)
        self.results[2].append(self.theta)

    def run(self, begin, end, step):
        self.reset()
        self.record(begin)

        self.dt = step
        time = arange(begin, end, step)[1:]
        for t in time:
            next_v = self.postsynaptic + self.dv(t)
            next_w = self.weights + self.dw(t)
            next_theta = self.theta + self.dtheta(t)

            self.postsynaptic = next_v
            self.weights = next_w
            self.theta = next_theta

            if self.constraining:
                self.constrain_weights()

            self.record(t)

        return self.results

    def plot(self, begin, end, step):
        time = arange(begin, end, step)
        v, w, theta = self.run(begin, end, step)

        plt.plot(time, v)
        plt.plot(time, map(lambda x: x.sum(), w))
        plt.plot(time, theta)
        plt.legend(('Postsynaptic Activity', 'Total Weights', 'Threshhold'))
