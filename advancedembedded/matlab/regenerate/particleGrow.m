function [particle, concentrations] = particleGrow(particle, grid)
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
home = particleConcentrations(grid, particle.position);

% particle does not move in this state unless a defect
% concentration is sensed.
motion = [0 0];

% the ultimate value for concentration, initialized to be unchanged
% from its current value.
concentrations = home;

% give distinct signals for defects along the horizontal and
% vertical axes.
defectSignals = [-2 -3];

% keep track of how many contacts this particle has.
contacts = 0;

inputs = 0;

% iterate through the four compass directions.
for compass=order
    % find the offset to the position in this compass direction.
    there = particle.position + compass';

    % what the defect signal value will be along this axis.  -2 is
    % for horizontal and -3 is for vertical.
    orientation = -abs(sum(defectSignals .* compass'));

    % see if this neighbor is actually in the boundary of the medium.
    if inBounds(grid, there)

        % If so, find the concentration at this position.
        surrounding = particleConcentrations(grid, there);

        % determine if another particle occupies this cell.
        other = grid.particleMatrix(there(1), there(2));
        
        if other > 0

            neighbor = grid.particles(other);
            if neighbor.contact > 0
                contacts = contacts + 1;
            end

        end
        
        if (particle.state == -orientation)

            % if the surrounding concentrations show this position
            % lies in a defect band
            if (surrounding(7+orientation) == orientation) ...
                    | (surrounding(7+orientation) == -1)

                % abandon this post and continue seeking.
                particle.state = 1;
                particle.contact = 0;
                concentrations(7+orientation) = orientation;
                motion = compass' * [0 1 ; 1 0];
                seeking = 0;

            % if the surrounding concentration is higher than
            % this particle is producing on its own.
            elseif (other == 0 & surrounding(-orientation) ...
                    > home(-orientation))

                % abandon this post and notify any particles
                % further down the chain.
                particle.state = 1;
                particle.contact = 0;
                concentrations(-orientation) = surrounding(-orientation) ...
                    - 1;
                motion = compass' * [0 1 ; 1 0];
                seeking = 0;

            elseif other == 0
                
                concentrations(-orientation) = particle.contact * 12;

            elseif other > 0

                inputs = inputs + 1;

                neighbor = grid.particles(other);

                if particle.contact < neighbor.contact - 1
                    particle.contact = neighbor.contact - 1;
                end

                if (particle.state == 3 ...
                    & (particle.contact < neighbor.contact)) ... 
                        | (particle.state == 2 ...
                           & (particle.contact > neighbor.contact))

                    particle.signal = neighbor.signal;

                end

            else

                

            end
        elseif particle.contact > 0 & other > 0
            neighbor = grid.particles(other);
            if neighbor.contact > 0 & not(neighbor.state == particle.state)

                % turn into the branching logic gate
                particle.state = 4;
                concentrations(2) = particle.contact * 12;
                concentrations(3) = particle.contact * 12;
                motion = [0 0];
                seeking = 0;

            end
        end
    else
        
    end

end

if inputs > 1
    
end

% find the ultimate location that the resulting motion implies.
going_into = particle.position + motion;

% if it lies outside of the grid or is occupied by another
% particle or a fault, motion is not possible that way.
if inBounds(grid, going_into) & ...
        (grid.particleMatrix(going_into(1), going_into(2)) == 0)

    % update the particle with its new position.
    particle.position = going_into;
end

% END CODE