function grid = runParticle(grid, chosen)
% runParticle - run the grid for the chosen particle.

% find the particle given by the chosen index.
particle = grid.particles(chosen)

% particles which are no longer intact through simulated transient
% fault are ignored. 
if particle.intact

    % apply the behavior of the particle to find the various
    % changes that will be applied to this particle and its cell.
    [changed, concentration] = particle.behavior(particle, grid);

    % set the concentration at the particle's current location to
    % the value determined by the behavior.
    grid.concentrations(particle.position(1), particle.position(2)) ...
        = concentration;

    % set the particle's new state as decided by the behavior, and
    % set the particle's behavior to the new behavior implied by
    % its new state.
    changed.behavior = grid.behaviors{changed.state};
    
    if not(all(changed.position == particle.position))
        grid.particleMatrix(particle.position(1), particle.position(2)) ...
            = 0;
        grid.particleMatrix(changed.position(1), changed.position(2)) = chosen;
    end

    grid.particles(chosen) = changed
end