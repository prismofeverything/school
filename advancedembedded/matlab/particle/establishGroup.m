function grid = establishGroup(grid, group)
% establishGroup - ensure all particles reference the same group.

% inputs:
%   grid - the grid the group is establishing itself within.
%   group - the group being established.
    
% outputs:
%   grid - the grid with the corresponding particles in the group
%   notified of the new group it belongs to.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

for n=1:length(group.indexes)
    % grab the index.
    index = group.indexes{n};

    % notify the particle at that index that it belongs to a new group.
    grid.particles{index(1), index(2)}.group = group;
end

