function rotated = indexesRotated90(group)

rotated = cellfun(@(index) [index(2), (group.dimension + 1) - index(1)], group.indexes);