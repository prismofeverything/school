function grid = populateGrid(grid, N)
% populateGrid - Place N particles on the grid.

% prevent an infinite loop should N hapen to be greater than the
% number of available cells.
if (N > grid.slots)
    N = grid.slots;
end

grid.particles = cell(1, N);
grid.groups = cell(1, N);

for n=1:N
    grid.particles{n} = initParticle();
    grid.groups{n} = initGroup(n);

    position = arrayfun(@randi, grid.dimension);
    while (grid.particleMatrix(position(1), position(2)) > 0)
        position = arrayfun(@randi, grid.dimension);
    end

    grid.particles{n}.position = position;
    %    grid.particles{n}.group = grid.groups(n);
    grid.particleMatrix(position(1), position(2)) = n;
end