function is = groupInBounds(grid, group)
% groupInBounds - check to see if the group lays within the grid.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

space = @(index) insideGrid(grid, index) && ...
                 spaceOpen(grid, index(1), index(2));
is = all(cellfun(space, group.indexes));

