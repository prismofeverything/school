function grid = addGroup(grid, group, particles)
% addGroup - add the given group of particles to the grid.

% inputs:
%   grid - the grid to add the group of particles into.
%   group - the group to add.
%   particles - the particles that correspond to the indexes held
%   by the group.

% outputs: 
%   grid - the grid with the given group of particles added.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

for n=1:length(particles)
    index = group.indexes{n};
    grid.particles{index(1), index(2)} = particles{n};
end

grid.groups = cat(2, grid.groups, group);
grid = establishGroup(grid, group);