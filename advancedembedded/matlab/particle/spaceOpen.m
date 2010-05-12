function decision = spaceOpen(grid, row, col)
% spaceOpen - determine whether the given space is open.

decision = isequal(grid.particles(row, col), {[]});

