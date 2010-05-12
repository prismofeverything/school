function decision = pathOpen(grid, indexes)
% pathOpen - determine whether the indexes are open.

decision = isequal(grid.particles(row, col), {[]});

