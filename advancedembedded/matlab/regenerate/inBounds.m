function in = inBounds(grid, point)
% inBounds - determine whether the given point lies within the grid.

% inputs:
%   grid - the grid providing the bounds.
%   point - the point in question

% outputs:
%   in - whether or not the point lies within the grid.

% BEGIN CODE

% we determine whether the given point lies within the grid by
% checking each component separately to ensure it lies between 1
% and the dimensions of the grid.  
in = point(1) >= 1 & point(1) <= grid.rows & ...
     point(2) >= 1 & point(2) <= grid.columns;

% END CODE