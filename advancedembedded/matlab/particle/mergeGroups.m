function group = mergeGroups(group, other)
% mergeGroups - merge two groups.

group.indexes = cat(2, group.indexes, other.indexes);
group = boundGroup(group);