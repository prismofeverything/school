function grid = establishGroup(grid, group)
% establishGroup - ensure all particles reference the same group.

for n=length(group.indexes)
    index = group.indexes{n};
    grid.particles{index(1), index(2)}.group = group;
end

