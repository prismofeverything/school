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
def plot_line(vertices):
    plt.plot(vertices[0], vertices[1])
    plt.title(title)
    plt.xlabel(which[0])
    plt.ylabel(which[1])
    plt.axis(ymin=-120, ymax=120)

# plotting a parametric surface.
def plot_layered(X, Y, Z, variable='X'):
    figure = plt.figure()
    ax = figure.add_subplot(111, projection='3d')
    ax.plot_surface(X, Y, Z, rstride=2, cstride=2, cmap=cm.jet)
    ax.set_xlabel('Time (ms)')
    ax.set_ylabel(variable)
    ax.set_zlabel('Voltage (mV)')
    
# plot the data as a series of trials.
def plot_series(time, variable, series, name='X'):
    minimum = -80
    figure = plt.figure()
    ax = figure.gca(projection='3d')

    def stub(tri):
        trial = map(lambda x: x - minimum, np.array(tri))
        trial[0] = 0
        trial[-1] = 0
        return trial

    verts = map(lambda trial: zip(time, stub(trial)), series)

    poly = PolyCollection(np.array(verts), facecolors=map(lambda n: cm.jet(n), np.linspace(0, 1, len(series))))
    poly.set_alpha(0.7)

    ax.add_collection3d(poly, zs=variable, zdir='y')
    ax.set_xlim3d(time[0], time[-1])
    ax.set_ylim3d(variable[0], variable[-1])
    ax.set_zlim3d(0, 80 - minimum)

    ax.set_xlabel('Time (ms)')
    ax.set_ylabel(name)
    ax.set_zlabel('Voltage + 80 (mV)')

