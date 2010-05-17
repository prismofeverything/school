function decision = pathOpen(grid, indexes)
% pathOpen - determine whether the indexes are open.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

decision = isequal(grid.particles(row, col), {[]});

