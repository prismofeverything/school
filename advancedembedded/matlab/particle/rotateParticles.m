function particles = rotateParticles(particles, vector)
% rotateParticles - rotate the configuration for each particle.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% create the rotation matrix by shifting the 4x4 identity.
rotation = circshift(eye(4), vector);
particles = arrayfun(@(n) rotateParticle(particles{n}, rotation), ...
                     1:length(particles), 'UniformOutput', 0);




