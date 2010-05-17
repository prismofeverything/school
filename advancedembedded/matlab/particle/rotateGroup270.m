function group = rotateGroup270(group)
% rotateGroup270 - rotate the given group by 270 degrees.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

swap = @(index) [(group.dim-(index(2)-group.col))+(group.row-1), ...
                 (index(1)-group.row)+group.col];
group.indexes = cellfun(swap, group.indexes, 'UniformOutput', 0);