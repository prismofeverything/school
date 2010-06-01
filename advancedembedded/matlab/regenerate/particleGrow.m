function [motion, concentration, state, contact] = particleGrow(particle, grid)
% particleGrow - grow a strand of particles in a direction given by
% the state.

% BEGIN CODE

% represent the four compass directions as offsets from a
% two-dimensional position in the grid.
compassDirections = [[-1; 0] [0; 1] [1; 0] [0; -1]];

% find the concentration in the grid the particle is currently occupying.
homeConcentration = grid.concentrations(particle.position(1), ...
                                        particle.position(2));

% the ultimate value for concentration, initialized to be unchanged
% from its current value.
concentration = homeConcentration;

% give a default motion unless some compelling reason to move
% elsewhere is found.
motion = [0 0];

% initialize the state to the particle's current state.
state = particle.state;

% whether or not the particle attains contact with a pad.
contact = particle.contact;

% give distinct signals for defects along the horizontal and
% vertical axes.
defectSignals = [-2 -3];

% iterate through the four compass directions.
for compass=compassDirections

end

% END CODE