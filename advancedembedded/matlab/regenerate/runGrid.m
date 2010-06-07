function grid = runGrid(grid)
% runGrid - run the grid for a single particle chosen at random.

% run each particle each time step.
for chosen = 1:50
    grid = runParticle(grid, chosen);
end

diffused = grid.concentrations(:, :, 2:3) - 1;
diffused(diffused < 0) = 0;
grid.concentrations(:, :, 2:3) = diffused;

% % find a random particle from the grid.
% chosen = randi(length(grid.particles))

% % run the grid given the chosen particle.
% grid = runParticle(grid, chosen);