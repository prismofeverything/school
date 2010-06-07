function grid = runSimulation(T)
% runSimulation - top level function for particle grid.

% runSimulation creates a new grid and supplies the states for the
% self-assembling fault-tolerant particle networks.  After
% initializing the grid, it runs through T timesteps and provides a
% visualization of the grid as it runs.

% inputs:
%   T - the number of timesteps to run the simulation.

% outputs:
%   grid - the newly created grid run for T timesteps.

% BEGIN CODE

% These are the state functions that are used for this particle
% system.  The states define the behavior each particle has as it
% is run and how the particle is transformed after the behavior
% takes place.
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

% END CODE