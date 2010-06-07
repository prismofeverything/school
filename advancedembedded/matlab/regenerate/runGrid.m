function grid = runGrid(grid)
% runGrid - run the grid for a single particle chosen at random.

% run each particle each time step.
for chosen = 1:50
    grid = runParticle(grid, chosen);

    % output the signal if affixed to the output pad.
    particle = grid.particles(chosen);
    if particle.position(2) == 12 & particle.signal(1) >= 0
        grid.output_pad = particle.signal(1);
    end
end

% diffuse the concentrations by one step.
diffused = grid.concentrations(:, :, 2:3) - 1;
diffused(diffused < 0) = 0;
grid.concentrations(:, :, 2:3) = diffused;

