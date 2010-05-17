function bounds = findBounds(indexes)
% findBounds - find a bounding box for the given indexes.

% inputs:
%   indexes - the indexes to find the bounding box for.
%   limits - the ultimate boundary of the grid.

% outputs: 
%   bounds - a list of three numbers signifying the boundaries of the
%   given group.  The first is the dimension of the group for
%   rotation purposes.  The second and third are the minimum row
%   and column value respectively.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% find all of the row values.
rowspan = cellfun(@(index) index(1), indexes);

% find all of the column values.
colspan = cellfun(@(index) index(2), indexes);

% determine the dimension of the bounding box for these indexes.
dimension = max(max(rowspan) - min(rowspan), max(colspan) - min(colspan));

% return the information as a tuple of three values.
bounds = [dimension + 1, min(rowspan), min(colspan)];