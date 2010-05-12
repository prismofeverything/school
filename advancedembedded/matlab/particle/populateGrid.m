function grid = populateGrid(grid, N)
% populateGrid - Place N particles on the grid.

% prevent an infinite loop should N hapen to be greater than the
% number of available cells.
if (N > grid.slots)
    N = grid.slots;
end

for n=1:N
    % find a unique position within the grid, regenerating the
    % index if there is already a particle in that position.
    position = arrayfun(@randi, grid.dimension);
    while (grid.particleMatrix(position(1), position(2)) > 0)
        position = arrayfun(@randi, grid.dimension);
    end

    % create a new particle.
    particle = initParticle();
    % create a new group to store the new particle.  In the
    % beginning, there is one group for each particle.
    group = initGroup(position);
    % create a reference to the group containing the particle.
    particle.group = group;

    % place the particle within the grid.
    grid.particles{position(1), position(2)} = particle;
    % place the group into the grid.
    grid.groups{n} = group;

    % create an entry in the particleMatrix indicating a particle
    % is now occupying that position.
    grid.particleMatrix(position(1), position(2)) = n;
end

% find the indexes to all of the particles
indexes = cellfun(@(g) g.indexes{1}, grid.groups, 'UniformOutput', 0);

for n=1:N
    % do the initial binding of particles as they landed in the grid.
    grid = bindParticle(grid, indexes{n});
end