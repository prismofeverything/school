function grid = runSimulation(T)
% runSimulation - top level function for particle grid.

behaviors = {@particleSeek, @particleGrow, @particleGrow, @particleGate};

% create a 12x12 grid.
grid = initGrid(12, 12, behaviors);

% add 50 particles to the grid.
grid = addParticles(grid, 50);

% run the given number of timesteps.
for timestep=1:T
    grid = runGrid(grid);
end
