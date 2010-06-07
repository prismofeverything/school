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

    % add some padding around the matrix so that it displays correctly.
    stateMatrix = grid.stateMatrix;
    stateMatrix = [stateMatrix zeros(length(stateMatrix), 1)];
    stateMatrix = [stateMatrix ; zeros(1, length(stateMatrix))];

    % plot the matrix
    pcolor(stateMatrix + 2);
    M(timestep) = getframe();
end
