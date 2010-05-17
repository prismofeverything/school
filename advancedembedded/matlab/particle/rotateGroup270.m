function group = rotateGroup270(group)
% rotateGroup270 - rotate the given group by 270 degrees.

% inputs:
%   group - the group to rotate.

% outputs:
%   group - the rotated group.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% the index is translated into relative coordinates, the entire
% group rotated within the relative bounds, and then cast back into
% absolute offsets.
swap = @(index) [(group.dim-(index(2)-group.col))+(group.row-1), ...
                 (index(1)-group.row)+group.col];
group.indexes = cellfun(swap, group.indexes, 'UniformOutput', 0);