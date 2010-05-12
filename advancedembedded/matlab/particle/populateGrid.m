function grid = populateGrid(grid, N)
% populateGrid - Place N particles on the grid.

% prevent an infinite loop should N hapen to be greater than the
% number of available cells.
if (N > grid.slots)
    N = grid.slots;
end

grid.groups = cell(1, N);

for n=1:N
    % find a unique position within the grid, regenerating the
    % index if there is already a particle in that position.
    position = arrayfun(@randi, grid.dimension);
    while (grid.particleMatrix(position(1), position(2)) > 0)
        position = arrayfun(@randi, grid.dimension);
    end

    grid.particles{position(1), position(2)} = initParticle();
    grid.groups{n} = initGroup(position);

    grid.particleMatrix(position(1), position(2)) = n;
end