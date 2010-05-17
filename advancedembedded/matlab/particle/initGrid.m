function grid = initGrid(rowMax, colMax)
% initGrid - Create an empty grid with dimensions rowMax and colMax

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

grid.dimension = [rowMax, colMax];
grid.slots = rowMax * colMax;
grid.particles = cell(rowMax, colMax);
grid.groups = {};
grid.particleMatrix = zeros(rowMax, colMax);



