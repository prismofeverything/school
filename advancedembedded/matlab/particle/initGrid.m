function grid = initGrid(rowMax, colMax)
% initGrid - Create an empty grid with dimensions rowMax and colMax

grid.dimension = [rowMax, colMax];
grid.slots = rowMax * colMax;
grid.particles = {};
grid.groups = {};
grid.particleMatrix = zeros(rowMax, colMax);
grid.spaceOpen = @(x, y) grid.particleMatrix(y, x) == 0;

% function how = pathOpen(indexes)
%     how = 
% end