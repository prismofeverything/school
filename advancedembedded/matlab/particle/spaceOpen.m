function decision = spaceOpen(grid, row, col)
% spaceOpen - determine whether the given space is open.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

decision = isequal(grid.particles(row, col), {[]});

