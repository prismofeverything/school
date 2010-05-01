function grid = populateGrid(grid,N)
% populateGrid - Place N particles on the grid.

% prevent an infinite loop should N hapen to be greater than the
% number of available cells.
if (N > grid.slots)
    N = grid.slots
end

for n=1:N
    grid.particles(n) = initParticle();
    grid.groups(n) = initGroup(n);

    position = arrayfun(@randi,grid.dimension);
    while (grid.particleMatrix(position(2),position(1)) > 0)
        position = arrayfun(@randi,grid.dimension);
    end

    grid.particles(n).position = position;
    grid.particleMatrix(position(2),position(1)) = n;
end