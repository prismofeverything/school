import numpy as np
from mpl_toolkits.mplot3d import axes3d

from matplotlib import cm
from matplotlib.collections import PolyCollection
from matplotlib import pyplot as plt

# return the X and Y matrices of a parametric surface 
# that corresponds to the shape of a given Z matrix.
def xy3d(Z):
    xs = range(0, Z.shape[1])
    ys = range(0, Z.shape[0])
    X = np.array(map(lambda y: xs, ys))
    Y = np.array(map(lambda y: map(lambda x: y, xs), ys))

    return X, Y

# plot a two-dimensional function
def plot_line(vertices, title='', which=False):
    plt.plot(vertices[0], vertices[1])
    plt.title(title)
    if which:
        plt.xlabel(which[0])
        plt.ylabel(which[1])
    plt.axis(ymin=min(vertices[1]), ymax=max(vertices[1]))

# plotting a parametric surface.
def plot_layered(X, Y, Z, ylabel='Y', zlabel='Z'):
    figure = plt.figure()
    ax = figure.add_subplot(111, projection='3d')
    ax.plot_surface(X, Y, Z, rstride=2, cstride=2, cmap=cm.jet)
    ax.set_xlabel('Time (ms)')
    ax.set_ylabel(ylabel)
    ax.set_zlabel(zlabel)
    
# plot the data as a series of trials.
def plot_series(time, variable, series, ylabel='Y', zlabel='Z', fromzero=False):
    figure = plt.figure()
    ax = figure.gca(projection='3d')

    globalmin = np.min(map(lambda trial: np.min(trial), series))
    globalmax = np.max(map(lambda trial: np.max(trial), series))

    def stub(trial):
        if not fromzero:
            trial = map(lambda x: x - globalmin, np.array(trial))
            trial[0] = 0

        trial[-1] = 0
        return np.array(trial)

    verts = map(lambda trial: zip(time, stub(trial)), series)
    poly = PolyCollection(np.array(verts), facecolors=map(lambda n: cm.jet(n), np.linspace(0, 1, len(series))))
    poly.set_alpha(0.7)

    if not fromzero:
        globalmax -= globalmin
        globalmin -= globalmin

    ax.add_collection3d(poly, zs=variable, zdir='y')
    ax.set_xlim3d(time[0], time[-1])
    ax.set_ylim3d(min(variable), max(variable))
    ax.set_zlim3d(globalmin, globalmax)

    ax.set_xlabel('Time (ms)')
    ax.set_ylabel(ylabel)
    ax.set_zlabel(zlabel)

