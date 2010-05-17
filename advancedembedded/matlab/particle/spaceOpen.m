function decision = spaceOpen(grid, row, col)
% spaceOpen - determine whether the given space is open.

% inputs:
%   grid - the grid containing particles.
%   row - the row that may or may not be open.
%   col - the column that may or may not be open.

% outputs:
%   decision - true or false based on whether the given space in
%   the grid is free or not.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% empty spaces are represented as empty cells.
decision = isequal(grid.particles(row, col), {[]});

