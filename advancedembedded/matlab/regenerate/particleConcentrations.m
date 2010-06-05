function concentrations = particleConcentrations(grid, position)
% particleConcentrations - the concentrations for a given location.

dim = size(grid.concentrations);
concentrations = reshape(grid.concentrations(position(1), position(2), ...
                                             :), 1, dim(3));







