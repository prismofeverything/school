function groups = removeGroup(groups, group)
% removeGroup - remove the given group from a list of groups.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

groups = groups(cellfun(@(g) ~isequal(group.indexes, g.indexes), groups));