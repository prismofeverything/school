function groups = removeGroup(groups, group)
% removeGroup - remove the given group from a list of groups.

groups = groups(cellfun(@(g) ~isequal(group, g), groups));