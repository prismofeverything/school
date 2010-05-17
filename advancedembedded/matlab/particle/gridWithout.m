function grid = gridWithout(grid, group)
% gridWithout - the grid with the given group removed.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

grid.groups = removeGroup(grid.groups, group);

for indexcell=group.indexes
    index = indexcell{1};

    % remove the particle reference.
    grid.particles{index(1), index(2)} = [];
    grid.particleMatrix(index(1), index(2)) = 0;
end