function grid = addParticles(grid, N)
% addParticles - add N particles to the grid.


% BEGIN CODE

% find the number of available cells in the grid.
availableCells = grid.rows * grid.columns - grid.defects;

% avoid an infinite loop looking for an open cell.
if (N > availableCells)
    N = availableCells;
end

% find the initial behavior.
behavior = grid.behaviors{1};

for n=1:N
    % choose a random position
    position = [randi(grid.rows), randi(grid.columns)];
    
    % if the position is occupied, repick another position until
    % it is not occupied.
    while (not(grid.particleMatrix(position(1), position(2)) == 0))
        position = [randi(grid.rows), randi(grid.columns)];
    end

    % create a reference to the newly created particle so that it
    % can be found directly given a particular row and column in
    % the grid.
    grid.particleMatrix(position(1), position(2)) = n;
    grid.stateMatrix(position(1), position(2)) = 1;

    % create a new particle at the given location and add it to the
    % grid's list of particles.
    particle = initParticle(position, behavior);
    grid.particles(n) = particle;
end

% END CODE