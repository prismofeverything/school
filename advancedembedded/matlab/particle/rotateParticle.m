function particle = rotateParticle(particle, rotation)
% rotateParticle - rotate the particle configuration

% inputs:
%   particle - the particle to be rotated.
%   rotation - a matrix representing the rotation to take place.

% outputs:
%   particle - the particle with the configuration rotated by the
%   given matrix.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% the rotation is accomplished as a simple matrix multiplication.
particle.configuration = particle.configuration * rotation;