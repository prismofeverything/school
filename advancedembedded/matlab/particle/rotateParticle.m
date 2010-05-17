function particle = rotateParticle(particle, rotation)
% rotateParticle - rotate the particle configuration

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

particle.configuration = particle.configuration * rotation;