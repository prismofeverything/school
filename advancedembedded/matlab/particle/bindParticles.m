function grid = bindParticles(grid, group)
% bindParticles - bind the particles associated to the given group.

% inputs:
%   grid - the grid of particles to bind.
%   group - the group of particles to seek binding with.

% outputs: 
%   grid - the grid with the given group of particles binded to as
%   many sites as possible.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% this function is really just a loop of bindParticle.
for n=1:length(group.indexes)
    grid = bindParticle(grid, group.indexes{n});
end