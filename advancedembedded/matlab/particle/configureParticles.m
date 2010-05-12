function grid = configureParticles(grid, configBitstream)
% configureParticles - Supply configuration for the particles.

% inputs:
%   grid - Grid containing particles.
%   configBitstream - A vector containing four values for every
%     particle in the particle grid.  These four values map to the
%     receptivity of the four sides of the particle.

% outputs: 
%   grid - The grid that was input.

bitRows = reshape(configBitstream, 4, length(configBitstream) / 4)';

for j=1:length(bitRows)
    grid.particles(j).configuration = bitRows(j , :);
end