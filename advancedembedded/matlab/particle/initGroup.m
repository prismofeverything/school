function group = initGroup(particleIndex)
% initGroup - Create a group with one particle.

% inputs: 
%   particle - an index to a particle in the grid.

% outputs:
%   group - a group is a container of indexes to particles that
%     have been linked together.  

group.indexes = {particleIndex};
group = boundGroup(group);