function grid = initGrid(xMax, yMax)
% initGrid - Create an empty grid with dimensions xMax and yMax

grid.dimension = [xMax, yMax];
grid.slots = xMax * yMax;
grid.particleMatrix = zeros(yMax, xMax);
