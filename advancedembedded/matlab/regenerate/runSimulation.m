function history = runSimulation(T)
% runSimulation - top level function for particle grid.

behaviors = {@particleSeek};

% create a 12x12 grid.
grid = initGrid(12, 12, behaviors);

% add 50 particles to the grid.
grid = addParticles(grid, 50);

history(1) = grid;

for timestep=1:T
    grid = runGrid(grid);
    history(timestep + 1) = grid;
end
