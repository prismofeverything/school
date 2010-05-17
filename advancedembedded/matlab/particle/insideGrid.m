function inside = insideGrid(grid, index)
% insideGrid - determine whether the index lies in the grid.

% inputs:
%   grid - the grid to test whether the index is within.
%   index - the index to test whether the grid contains it.

% outputs:
%   inside - true or false depending on the outcome.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% test the index against the dimensions of the grid.
inside = (index(1) > 0) & (index(1) <= grid.dimension(1)) & ...
         (index(2) > 0) & (index(2) <= grid.dimension(2));
