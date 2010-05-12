function grid = gridWithout(grid, group)
% gridWithout - the grid with the given group removed.

grid.groups = removeGroup(grid.groups, group);

for indexcell=group.indexes
    index = indexcell{1};
    grid.particles{index(1), index(2)} = [];
    grid.particleMatrix(index(1), index(2)) = 0;
end