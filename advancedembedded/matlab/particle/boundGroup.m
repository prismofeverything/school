function group = boundGroup(group)
% boundGroup - find a bounding box for the group's indexes.

% inputs:
%   group - the group to find the bounding box for.

% outputs: 
%   group - the group with a new bounds assigned.

bounds = findBounds(group.indexes);
group.dimension = bounds(1)
group.row = bounds(2);
group.col = bounds(3);
