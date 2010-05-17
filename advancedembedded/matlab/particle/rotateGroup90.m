function group = rotateGroup90(group)
% rotateGroup90 - rotate the given group by 90 degrees.

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
swap = @(index) [(index(2)-group.col) + group.row, ...
                 (group.dim - (index(1)-group.row)) + (group.col-1)];
group.indexes = cellfun(swap, group.indexes, 'UniformOutput', 0);

