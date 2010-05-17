function group = mergeGroups(group, other)
% mergeGroups - merge two groups.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

group.indexes = cat(2, group.indexes, other.indexes);
group = boundGroup(group);
