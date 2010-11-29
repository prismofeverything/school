from integration import *

class FitzhughNagumo(Integration):
    def __init__(self, f=lambda V: V - (pow(V, 3) * 0.33333333), I=lambda t: 0, tau=0.1, tauR=0.5, a=1.25, b=1, c=1.5):
        self.f = f
        self.I = I
        self.tau = tau
        self.tauR = tauR
        self.a = a
        self.b = b
        self.c = c
        self.Vvar = Variable('V', lambda xi, t: (1.0 / xi.tau) * (f(xi.V) - xi.R + xi.I(t)), -1.5)
        self.Rvar = Variable('R', lambda xi, t: (1.0 / xi.tauR) * ((xi.a * xi.V) - (xi.b * xi.R) + xi.c), -0.375)

        Integration.__init__(self, [self.Vvar, self.Rvar])

    def VRgivenI(self, I):
        V = roots([(1.0/3), 0, .25, 1.5 - I])
        R = 1.25 * V + 1.5
        return [V, R]

    def eigen(self, V):
        """the eigenvalues for the system given a particular V"""
        return roots([1, (10 * pow(V, 2) - 8), 20 * pow(V, 2)])

