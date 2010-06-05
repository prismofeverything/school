function [particle, concentration] = particleGrow(particle, grid)
% particleGrow - grow a strand of particles in a direction given by
% the state.

% BEGIN CODE

% represent the four compass directions as offsets from a
% two-dimensional position in the grid.
compassDirections = [[-1; 0] [0; 1] [1; 0] [0; -1]];

% keep the compass directions rotated randomly to ensure no direction is
% favored over any other direction.
offset = randi(4);
order = [compassDirections(:, (offset+1):4), compassDirections(:, 1:offset)];

% find the concentration in the grid the particle is currently occupying.
homeConcentration = grid.concentrations(particle.position(1), ...
                                        particle.position(2));

% the ultimate value for concentration, initialized to be unchanged
% from its current value.
concentration = homeConcentration;

% give distinct signals for defects along the horizontal and
% vertical axes.
defectSignals = [-2 -3];

% keep track of how many contacts this particle has.
contacts = 0;

% iterate through the four compass directions.
for compass=order
    % find the offset to the position in this compass direction.
    there = particle.position + compass';

    % what the defect signal value will be along this axis.  -2 is
    % for horizontal and -3 is for vertical.
    defectOrientation = -abs(sum(defectSignals .* compass'));

    % see if this neighbor is actually the boundary of the medium.
    if inBounds(grid, there)

        % If so, find the concentration at this position.
        surroundingConcentration = grid.concentrations(there(1), there(2));

        % determine if another particle occupies this cell.
        other = grid.particleMatrix(there(1), there(2));
        
        if other > 0
            neighbor = grid.particles(other);
            if neighbor.contact > 0
                contacts = contacts + 1;
            end
        end
        
        if (particle.state == -defectOrientation)
            if (surroundingConcentration == defectOrientation) | ...
               (surroundingConcentration == -1)
                particle.state = 1;
                concentration = defectOrientation;
                motion = compass' * [0 1 ; 1 0];
            elseif other == 0
                concentration = particle.contact + 1;
            end
        end
    else
        
    end
end

% END CODE