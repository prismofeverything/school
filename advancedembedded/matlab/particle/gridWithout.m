function grid = gridWithout(grid, group)
% gridWithout - the grid with the given group removed.

% inputs:
%   grid - the grid that contains the given group.
%   group - the group of particles to remove from the grid.

% outputs:
%   grid - the grid with the given group removed.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% remove the group from the grid's list.
grid.groups = removeGroup(grid.groups, group);

% remove each particle that is part of this group from the grid.
for indexcell=group.indexes
    % unpack the index.
    index = indexcell{1};

    % remove the particle reference.
    grid.particles{index(1), index(2)} = [];
end