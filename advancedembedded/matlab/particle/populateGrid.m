function grid = populateGrid(grid, configBitstream)
% populateGrid - create particles corresponding to the bitstream
% and place them in the grid. 

% inputs:
%   grid - the grid to populate.
%   configBitstream - the configuration of the particles that are
%   to be added to the grid.

% outputs:
%   grid - the resulting populated grid.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% find the number of particles.  We assume the bitstream is
% divisble by 4, as each particle has four sides.
N = length(configBitstream) / 4;

% prevent an infinite loop should N hapen to be greater than the
% number of available cells.
if (N > grid.slots)
    N = grid.slots;
end

bitRows = reshape(configBitstream, 4, N)';

for n=1:N
    % find a unique position within the grid, regenerating the
    % index if there is already a particle in that position.
    position = arrayfun(@randi, grid.dimension);
    while (~isequal(grid.particles{position(1), position(2)}, []))
        position = arrayfun(@randi, grid.dimension);
    end

    % find the configuration for this particle.
    configuration = bitRows(n,:);
    % create a new particle.
    particle = initParticle(configuration);
    % create a new group to store the new particle.  In the
    % beginning, there is one group for each particle.
    group = initGroup(position);
    % create a reference to the group containing the particle.
    particle.group = group;

    % place the particle within the grid.
    grid.particles{position(1), position(2)} = particle;
    % place the group into the grid.
    grid.groups{n} = group;
end

indexes = cellfun(@(g) g.indexes{1}, grid.groups, 'UniformOutput', 0);

% bind all of the particles in all of the groups to their neighbors
% if they are found to be compatible.
for n=1:length(indexes)
    grid = bindParticle(grid, indexes{n});
end
