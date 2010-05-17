function particles = particlesFor(grid, group)
% particlesFor - get the particles the indexes in this group
% correspond to.

% inputs:
%   grid - the grid containing the particles.
%   group - the group of indexes.

% outputs:
%   particles - a cellarray containing the particles found in the
%   grid that correspond to the indexes held by the given group.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

particles = cellfun(@(index) grid.particles{index(1), index(2)}, ...
                    group.indexes, 'UniformOutput', 0);