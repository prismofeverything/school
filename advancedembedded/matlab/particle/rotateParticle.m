function particle = rotateParticle(particle, rotation)
% rotateParticle - rotate the particle configuration

particle.configuration = particle.configuration * rotation;