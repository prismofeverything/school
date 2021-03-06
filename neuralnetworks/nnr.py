from pylab import *

def suffix(n):
    s = str(n)
    p = '0' * (3-len(s))
    return p + s

def pull(filename):
    contents = open(filename).read()
    lines = contents.split("\n")
    lines.pop()
    data = array(map(lambda line: map(lambda x: float(x), line.split(" ")[1:]), lines))

    return data

class NNR:
    def __init__(self, filename):
        self.filename = filename

        contents = open(filename).read()
        lines = contents.split("\n")
        lines.pop()

        self.data = array(map(lambda line: map(lambda x: float(x), line.split("\t")[1:]), lines))

        self.outputs = self.data.shape[1] / 2
        self.expected = self.data[:,:self.outputs]
        self.results = self.data[:,self.outputs:]
        self.diff = self.expected - self.results
        self.mask = self.expected * self.results

        self.strict = map(lambda p: all(map(lambda x: abs(x) < 0.2, p)), self.diff)
        self.loose = map(lambda p: abs(sum(p) - 1.0) < 0.2, self.mask)

        self.error = sum(self.diff)

    def performance(self):
        return float(sum(self.loose)) / float(len(self.loose))

class Series:
    def __init__(self, base, steps, desc):
        self.base = base
        self.steps = steps
        self.desc = desc

        self.nnr = map(lambda x: NNR(base+suffix(x)), range(steps))
        self.data = array(map(lambda d: d.performance(), self.nnr))

    def plot(self):
        plot(self.data, label=self.desc)

class Experiment:
    def __init__(self, series, steps):
        self.series = map(lambda s: Series('phtrain/'+s[0], steps, s[1]), series)
        
    def plot(self):
        xlabel('trials')
        ylabel('percent correct')
        for s in self.series:
            s.plot()
        legend(loc='center')

def run():
    experiment = Experiment([('5features', 'critical five features'), 
                             ('5control', 'arbitrary five features')], 12)

    # experiment = Experiment([('52features50PE', '50 PEs'), 
    #                          ('52features15PE', '15 PEs')], 12)

    # experiment = Experiment([('fourmom', 'momentum=0.4'), 
    #                          ('twomom', 'momentum=0.2'),
    #                          ('epoch64', 'epoch=64'),
    #                          ('highlcoef', 'lcoef=0.75'),
    #                          ('sine', 'sine transfer'),
    #                          ('quickprop', 'quickprop')], 16)

    experiment.plot()
    return experiment
