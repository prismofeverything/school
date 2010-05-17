function group = boundGroup(group)
% boundGroup - find a bounding box for the group's indexes.

% inputs:
%   group - the group to find the bounding box for.

% outputs: 
%   group - the group with a new bounds assigned.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% call findBounds to discover the bounds and then assign the
% relevant information to the group.
bounds = findBounds(group.indexes);
group.dim = bounds(1);
group.row = bounds(2);
group.col = bounds(3);
