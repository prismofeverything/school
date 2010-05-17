function grid = initGrid(rowMax, colMax)
% initGrid - Create an empty grid with dimensions rowMax and colMax

% The grid is represented as a structure with four properties.  The
% dimension corresponds to the row and column maximums supplied to
% the function.  The slots holds the total number of open spaces
% particles can occupy.  Particles is a cell matrix holding the
% particles in their various positions within the grid.  Groups
% contains the list of conglomerations of particles, as they
% develop throughout a run.

% inputs:
%   rowMax - the number of rows for the grid.
%   colMax - the number of columns for the grid.

% outputs:
%   grid - a newly created grid of the given dimensions.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

grid.dimension = [rowMax, colMax];
grid.slots = rowMax * colMax;
grid.particles = cell(rowMax, colMax);
grid.groups = {};




