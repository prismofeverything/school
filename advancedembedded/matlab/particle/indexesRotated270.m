function rotated = indexesRotated270(group)

swap = @(index) [(group.dim-(index(2)-group.col))+(group.row-1), ...
                 (index(1)-group.row) + group.col];
rotated = cellfun(swap, group.indexes, 'UniformOutput', 0);