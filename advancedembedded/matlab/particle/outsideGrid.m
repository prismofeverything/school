function outside = outsideGrid(grid, index)
% outsideGrid - determine if the index lies outside the grid.

% inputs:
%   grid - the grid to test whether the index is outside.
%   index - the index to test inclusion within the grid.

% outputs:
%   outside - true or false depending on the outcome.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

inside = (index(1) > 0) & (index(1) <= grid.dimension(1)) & ...
         (index(2) > 0) & (index(2) <= grid.dimension(2));
outside = ~inside;