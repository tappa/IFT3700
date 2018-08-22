import pickle, gzip, os
from collections import namedtuple

class Mnist(object):
    def __init__(self):
        with gzip.open('datasets/mnist.pkl.gz', 'rb') as f:
            train, valid, test = pickle.load(f, encoding='latin1')
        Datasets = namedtuple('Datasets', ['x','y'])
        self.train = Datasets(x=train[0], y=train[1])
        self.valid = Datasets(x=valid[0], y=valid[1])
        self.test = Datasets(x=test[0], y=test[1])
        
class Adult(object):
    def __init__(self):
        with open('datasets/Adult/data') as f: data = f.read()
        self.train = [row.split(', ') for row in data.split('\n')]
        
        with open('datasets/Adult/valid') as f: data = f.read()
        self.valid = [row.split(', ') for row in data.split('\n')]