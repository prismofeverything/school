function particles = rotateParticles(particles, vector)
% rotateParticles - rotate the configuration for each particle.

% inputs:
%   particles - the particles whose configuration needs to be
%   rotated.
%   vector - the vector defining the shift of the identity matrix
%   in order to generate the expected rotation.

% outputs:
%   particles - the cellarray of particles whose configurations
%   have been rotated in the given direction.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% create the rotation matrix by shifting the 4x4 identity.
rotation = circshift(eye(4), vector);
particles = arrayfun(@(n) rotateParticle(particles{n}, rotation), ...
                     1:length(particles), 'UniformOutput', 0);




