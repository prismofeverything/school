function grid = runParticle(grid, chosen)
% runParticle - run the grid for the chosen particle.

% find the particle given by the chosen index.
particle = grid.particles(chosen)

% particles which are no longer intact through simulated transient
% fault are ignored. 
if particle.intact

    % apply the behavior of the particle to find the various
    % changes that will be applied to this particle and its cell.
    [motion, concentration, state, contact] = ... 
        particle.behavior(particle, grid)

    % set the concentration at the particle's current location to
    % the value determined by the behavior.
    grid.concentrations(particle.position(1), particle.position(2)) ...
        = concentration;

    % set the particle's new state as decided by the behavior, and
    % set the particle's behavior to the new behavior implied by
    % its new state.
    grid.particles(chosen).state = state;
    grid.particles(chosen).behavior = grid.behaviors{state};
    
    % Translate the particles position by the motion vector to find
    % the new location of the particle.
    translated = particle.position + motion;

    % Determine if the new translated location actually lies within
    % the grid.
    if inBounds(grid, translated)
        grid.particleMatrix(particle.position(1), particle.position(2))=0;
        grid.particles(chosen).position = translated;
        grid.particleMatrix(translated(1), translated(2)) = chosen;
    end
end