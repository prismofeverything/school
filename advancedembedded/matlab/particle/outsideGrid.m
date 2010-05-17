function outside = outsideGrid(grid, index)
% outsideGrid - determine if the index lies outside the grid.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

inside = (index(1) > 0) & (index(1) <= grid.dimension(1)) & ...
         (index(2) > 0) & (index(2) <= grid.dimension(2));
outside = ~inside;