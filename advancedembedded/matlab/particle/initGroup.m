function group = initGroup(particleIndex)
% initGroup - Create a group with one particle.

% groups are collections of indexes to particles that have been
% bound together.  They move as a unit and rotate as a unit.

% inputs: 
%   particle - an index to a particle in the grid.

% outputs:
%   group - a group is a container of indexes to particles that
%     have been linked together.  

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% at first the group contains only a single particle.
group.indexes = {particleIndex};

% find the dimensions and offset into the grid for this group.
group = boundGroup(group);