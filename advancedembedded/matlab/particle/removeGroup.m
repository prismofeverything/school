function groups = removeGroup(groups, group)
% removeGroup - remove the given group from a list of groups.

% inputs:
%   groups - a list of groups containing the given group.
%   group - the group to be removed.

% outputs:
%   groups - the list of groups with the given group removed.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

groups = groups(cellfun(@(g) ~isequal(group.indexes, g.indexes), groups));