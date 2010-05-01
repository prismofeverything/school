function particle = initParticle()
% initParticle - Create an empty particle.

% The particle's position within the grid context.
particle.position = [1 1];

% The configuration specifies the particle's receptivity in each
% of the four cardinal directions, going [N E S W].  If two
% adjacent sides are inverses they link together.
particle.configuration = [1 1 -1 -1];