from pylab import *

def gaussian(a, b, c):
    return lambda x: exp(a * pow(x, 2) + b * x + c)

class Cercal:
    def __init__(self):
        self.sensitivities = array([pi/4, 3*pi/4, 5*pi/4, 7*pi/4])
        self.mean = 0
        self.deviation = 5

    def true_rates(self, wind):
        return 50 * cos(wind - self.sensitivities)

    def noisify(self, rates):
        return rates + normal(self.mean, self.deviation, 4)

    def rectify(self, rates):
        return where(rates > 0, rates, 0)

    def rates(self, wind):
        return self.rectify(self.noisify(self.true_rates(wind)))

    def estimate(self, wind):
        rates = self.rates(wind)
        x = rates.dot(cos(self.sensitivities))
        y = rates.dot(sin(self.sensitivities))
        return arctan2(y, x)

    def estimatedVStrue(self):
        thetas = linspace(-pi, pi, 1000)
        plot(thetas, map(lambda theta: self.estimate(theta), thetas))

    def error(self, theta):
        return pow(theta - self.estimate(theta), 2)

    def trial(self, theta):
        over = arange(0, 1000, 1)
        return sqrt(sum(map(lambda ii: self.error(theta), over)))

    def trials(self, thetas):
        return map(lambda theta: self.trial(theta), thetas)

    def plot_trials(self):
        thetas = linspace(-pi*0.5, pi*0.5, 100)
        plot(thetas, self.trials(thetas))
