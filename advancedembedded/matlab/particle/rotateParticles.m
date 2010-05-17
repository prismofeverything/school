function particles = rotateParticles(particles, vector)
% rotateParticles - rotate the configuration for each particle.

rotation = circshift(eye(4), vector);
particles = arrayfun(@(n) rotateParticle(particles{n}, rotation), ...
                     1:length(particles), 'UniformOutput', 0);




