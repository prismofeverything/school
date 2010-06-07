function concentrations = particleConcentrations(grid, position)
% particleConcentrations - the concentrations for a given location.

% inputs:
%   grid - the grid housing the concentrations.
%   position - the location in the grid to fetch the concentrations from.

% outputs:
%   concentrations - the set of concentrations for this position in
%   this grid.

% BEGIN CODE

dim = size(grid.concentrations);
concentrations = reshape(grid.concentrations(position(1), position(2), ...
                                             :), 1, dim(3));

% END CODE




