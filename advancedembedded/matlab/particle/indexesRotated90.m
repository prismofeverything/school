function rotated = indexesRotated90(group)

swap = @(index) [(index(2)-group.col) + group.row, ...
                 (group.dim - (index(1)-group.row)) + (group.col-1)];
rotated = cellfun(swap, group.indexes, 'UniformOutput', 0);