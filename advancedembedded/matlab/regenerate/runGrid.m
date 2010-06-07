function grid = runGrid(grid)
% runGrid - run the grid for a single particle chosen at random.

% This function runs each particle in the grid once, and manages
% all the meta-level operations of dissolving the concentrations
% and outputting any signals from particles affixed to the output pad.

% inputs:
%   grid - the grid to be run.

% outputs:
%   grid - the grid cycled through one time step.

% BEGIN CODE

% run each particle each time step.
for chosen = 1:50

    % if we happen to roll below the fault rate.
    if rand() < 0.001

        % this is a transient fault.  Remove this particle from the grid.
        grid = transientFault(grid, chosen);

    else
        
        % run the particle as normal.
        grid = runParticle(grid, chosen);

        % output the signal if affixed to the output pad.
        particle = grid.particles(chosen);
        if particle.position(2) == 12 & particle.signal(1) >= 0 & ...
                particle.contact > 0
            grid.output_pad = particle.signal(1);
        end

    end

end


% diffuse the concentrations by one step.
diffused = grid.concentrations(:, :, 2:3) - 1;
diffused(diffused < 0) = 0;
grid.concentrations(:, :, 2:3) = diffused;

% END CODE