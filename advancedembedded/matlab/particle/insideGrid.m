function inside = insideGrid(grid, index)

inside = (index(1) > 0) & (index(1) <= grid.dimension(1)) & ...
         (index(2) > 0) & (index(2) <= grid.dimension(2));
