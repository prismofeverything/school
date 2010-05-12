function grid = runGrid(grid)
% runGrid - Run the given particle grid for one time step.

chosen = randi(length(grid.groups));
group = grid.groups(chosen);

