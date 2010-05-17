function is = groupInBounds(grid, group)
% groupInBounds - check to see if the group lays within the grid.

% inputs:
%   grid - the grid that represents the bounds the group can
%   occupy.
%   group - the group to check indexes for.

% outputs:
%   is - a one or zero depending on whether the group lies within
%   the bounds of the grid.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% to be a valid placement, the index must be both inside the grid
% and also not indexing an already occupied space.
space = @(index) insideGrid(grid, index) && ...
                 spaceOpen(grid, index(1), index(2));
is = all(cellfun(space, group.indexes));

