variables = {
    'excellent': {8:0.2,9:0.6,10:1.0},
    'good': {6:0.1,7:0.5,8:0.9,9:1.0,10:1.0},
    'fair': {2:0.3,3:0.6,4:0.9,5:1.0,6:0.9,7:0.5,8:0.1},
    'bad': {1:1.0,2:0.7,3:0.4,4:0.1}
}

class FuzzyVariable:
    def __init__(self, key, membership, context=None):
        self.key = key
        self.membership = membership
        if not context:
            self.context = self.membership.keys()
        else:
            self.context = context

    def keyContext(self, keys):
        self.context = keys

    def contains(self, key):
        return self.membership.has_key(key)

    def member(self, key):
        if self.contains(key):
            return self.membership[key]
        else:
            return 0.0

    def fuzzNot(self):
        notted = {}
        for key in self.context:
            value = 0.0
            if self.membership.has_key(key):
                value = self.membership[key]
            if value < 1.0:
                notted[key] = 1.0 - value

        result = FuzzyVariable('not '+self.key, notted, self.context)
        return result

    def fuzzVery(self):
        veryd = {}
        for key in self.membership.keys():
            veryd[key] = pow(self.membership[key], 2)

        result = FuzzyVariable('very '+self.key, veryd, self.context)
        return result

    def fuzzBinary(self, other, operation, combine):
        anded = {}
        for key in self.context:
            value = combine(self.member(key), other.member(key))
            if value > 0.0:
                anded[key] = value

        result = FuzzyVariable(self.key+' '+operation+' '+other.key, anded, self.context)
        return result

    def fuzzAnd(self, other):
        return self.fuzzBinary(other, 'and', lambda x,y: min([x,y]))

    def fuzzOr(self, other):
        return self.fuzzBinary(other, 'or', lambda x,y: max([x,y]))

class Fuzzy:
    def __init__(self, variables):
        self.variables = {}
        self.keys = set()

        for v in variables.keys():
            self.variables[v] = FuzzyVariable(v, variables[v])
            self.keys = self.keys.union(variables[v].keys())

        for v in self.variables.keys():
            self.variables[v].keyContext(self.keys)

    def variable(self, key):
        return self.variables[key]

    # def parse(self, statement):
    #     tokens = statement.split(' ')
    #     while len(tokens) > 0:
    #         head = tokens[0]
            

theory = Fuzzy(variables)

excellent = theory.variable('excellent')
notExcellent = excellent.fuzzNot()
notBad = theory.variable('bad').fuzzNot()
notVeryGood = theory.variable('good').fuzzVery().fuzzNot()

notBadButNotVeryGood = notBad.fuzzAnd(notVeryGood)
goodButNotExcellent = theory.variable('good').fuzzAnd(notExcellent)
fairToExcellent = theory.variable('fair').fuzzOr(excellent)
