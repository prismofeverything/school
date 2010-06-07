function grid = runParticle(grid, chosen)
% runParticle - run the grid for the chosen particle.

% inputs:
%   grid - the grid housing the particle.
%   chosen - the index to the particle to be run.

% outputs:
%   grid - the grid with the given particle advanced by one timestep.

% BEGIN CODE

% find the particle given by the chosen index.
particle = grid.particles(chosen);

% particles which are no longer intact through simulated transient
% fault are ignored. 
if particle.intact

    % apply the behavior of the particle to find the various
    % changes that will be applied to this particle and its cell.
    % The concentrations are a structure of defect concentration and
    % terminal concentration.
    [changed, concentrations] = particle.behavior(particle, grid);

    % set the concentration at the particle's current location to
    % the value determined by the behavior.
    grid.concentrations(particle.position(1), particle.position(2), ...
                        :) = concentrations;

    % set the particle's new state as decided by the behavior, and
    % set the particle's behavior to the new behavior implied by
    % its new state.
    changed.behavior = grid.behaviors{changed.state};
    
    % update the state and particle matrices with their new
    % values if they have changed.
    if not(all(changed.position == particle.position))
        grid.particleMatrix(particle.position(1), particle.position(2)) = 0;
        grid.particleMatrix(changed.position(1), changed.position(2)) = chosen;

        grid.stateMatrix(particle.position(1), particle.position(2)) = 0;
        grid.stateMatrix(changed.position(1), changed.position(2)) = changed.state;
    end
    
    if not(changed.state == particle.state)
        grid.stateMatrix(particle.position(1), particle.position(2)) = 0;
        grid.stateMatrix(changed.position(1), changed.position(2)) = changed.state;
    end

    grid.particles(chosen) = changed;

end

% END CODE