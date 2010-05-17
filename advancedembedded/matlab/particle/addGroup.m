function grid = addGroup(grid, group, particles)
% addGroup - add the given group of particles to the grid.

for n=1:length(particles)
    index = group.indexes{n}
    grid.particles{index(1), index(2)} = particles{n}
    grid = bindParticle(grid, index);
end

grid.groups = cat(2, grid.groups, group)