function grid = runGrid(grid)

% find a random particle from the grid.
chosen = randi(length(grid.particles));
particle = grid.particles(chosen);

% particles which are no longer intact through simulated transient
% fault are ignored. 
if particle.intact
    [motion, concentration, state, contact] = ... 
        particle.behavior(particle, grid)
    grid.concentrations(particle.position(1), particle.position(2)) ...
        = concentration;
    grid.particles(chosen).state = state
    grid.particles(chosen).behavior = grid.behaviors{state};
    
    % move the particle if motion is implied.
    grid.particleMatrix(particle.position(1), particle.position(2))=0;
    translated = particle.position + motion;
    grid.particles(chosen).position = translated;
    grid.particleMatrix(translated(1), translated(2)) = chosen;
end