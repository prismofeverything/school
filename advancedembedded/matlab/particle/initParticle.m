function particle = initParticle()
% initParticle - Create an empty particle.

% The configuration specifies the particle's receptivity in each
% of the four cardinal directions, going [N E S W].  If two
% adjacent sides are inverses they link together.
particle.configuration = [1 0 -1 0];
