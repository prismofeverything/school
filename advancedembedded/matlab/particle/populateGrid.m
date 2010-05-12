function grid = populateGrid(grid, N)
% populateGrid - Place N particles on the grid.

% prevent an infinite loop should N hapen to be greater than the
% number of available cells.
if (N > grid.slots)
    N = grid.slots;
end

grid.groups = cell(1, N/2);

for n=1:N
    % find a unique position within the grid, regenerating the
    % index if there is already a particle in that position.
    position = arrayfun(@randi, grid.dimension);
    while (grid.particleMatrix(position(1), position(2)) > 0)
        position = arrayfun(@randi, grid.dimension);
    end

    particle = initParticle();
    grid.particles{position(1), position(2)} = particle;
    group = initGroup(position);
    particle.group = group;
    grid.groups{n} = group;

    % hack in the creation of groups, for testing
%     if (mod(n, 2) == 0)
%         grid.groups{n/2} = mergeGroups(grid.groups{n/2}, group);
%     else
%         grid.groups{(n+1)/2} = group;
%     end

    grid.particleMatrix(position(1), position(2)) = n;
end