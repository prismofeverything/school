function group = rotateGroup90(group)
% rotateGroup90 - rotate the given group by 90 degrees.

swap = @(index) [(index(2)-group.col) + group.row, ...
                 (group.dim - (index(1)-group.row)) + (group.col-1)];
group.indexes = cellfun(swap, group.indexes, 'UniformOutput', 0);

