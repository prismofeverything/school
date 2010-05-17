function is = groupInBounds(grid, group)
% groupInBounds - check to see if the group lays within the grid.

space = @(index) insideGrid(grid, index) && ...
                 spaceOpen(grid, index(1), index(2));
is = all(cellfun(space, group.indexes));

