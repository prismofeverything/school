from integration import *

def osc_rate(t):
    return 0.1 * (1 + cos(2 * pi * t / 300))

class Poisson:
    def __init__(self, rate=lambda t: 0.1, rest=0, spike=1):
        self.rate = rate
        self.rest = rest
        self.spike = spike
        
    def tick(self, t):
        if random.random() < self.rate(t):
            return self.spike
        else:
            return self.rest

    def generate(self, ticks):
        return map(lambda t: self.tick(t), range(ticks))

class Approximate(Integration):
    def __init__(self, dt=1, tau=1, ticks=1000):
        self.tau = tau
        self.itau = 1.0 / tau
        self.poisson = Poisson(osc_rate)
        self.ticks = ticks
        self.spikes = self.poisson.generate(self.ticks)

        Integration.__init__(self, dt)

    def reset(self):
        self.rate = 0

    def snapshot(self):
        return {'rate': self.rate}

    def step(self, t):
        if self.spikes[t] > 0:
            self.rate += self.itau
        else:
            self.rate -= self.rate * self.itau

class CompareApproximation:
    def __init__(self):
        self.approx = Approximate()
        self.time = arange(0, self.approx.ticks, 1)
        self.true = osc_rate(array(self.time))
        self.taus = arange(1, 100, 1)

    def calculate_error(self):
        errors = []

        for tau in self.taus:
            self.approx.itau = 1.0 / tau
            self.approx.run(0, self.approx.ticks, 1)

            error = sum(pow(self.true - array(self.approx.traces['rate']), 2))
            errors.append(error)

        return errors

    def plot_error(self):
        errors = self.calculate_error()

        plt.figure()
        plt.plot(self.taus[10:], errors[10:])

    def plot_all(self):
        errors = self.calculate_error()
        min_tau = argmin(errors)
        self.approx.itau = 1.0 / min_tau
        self.approx.run(0, self.approx.ticks, 1)

        plt.figure()
        plt.plot(self.time, array(self.approx.spikes) * 0.05)
        plt.plot(self.time, self.true)
        plt.plot(self.time, self.approx.traces['rate'])
        plt.legend(['spikes', 'true rate', 'tau = ' + str(min_tau)], loc='upper left')
