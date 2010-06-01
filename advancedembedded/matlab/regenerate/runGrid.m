function grid = runGrid(grid)
% runGrid - run the grid for a single particle chosen at random.

% find a random particle from the grid.
chosen = randi(length(grid.particles))

% run the grid given the chosen particle.
grid = runParticle(grid, chosen);