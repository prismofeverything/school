function [particle, concentrations] = particleGrow(particle, grid)
% particleGrow - grow a strand of particles in a direction given by
% the state.

% The grow state is very simple, the particle stays rooted where it
% is and emits a concentration proportional to the length of the
% wire.  As a new particle becomes attached, it notes a length one
% longer than the particle it is attaching to, and the original one
% stops emitting a concentration while the new one starts emitting
% a stronger concentration.
    
% To avoid a multitude of particles affixing as tiny wires along
% the length of the input or output pad, particles in the GROW
% state also look for surrounding concentrations higher than the
% ones they themselves are emitting.  This is a signal that a
% larger wire exists in the environment, and triggers the GROW
% state to revert back to SEEK.  As it reverts, this reverts the
% next particle down, triggering the dissolution of the shorter wire. 

% inputs:
%   particle - the particle in question.
%   grid - the grid context of the particle.

% outputs:
%   particle - the particle transformed by the behavior.
%   concentrations - the concentrations vector the particle is
%   leaving behind.

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
            if neighbor.contact > 0 & neighbor.state == -orientation
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

            % if there is no particle occupying this slot
            elseif other == 0
                
                % start a concentration to attract particles to the terminal.
                concentrations(-orientation) = particle.contact * 12;

            % if there is a particle here
            elseif other > 0

                inputs = inputs + 1;

                neighbor = grid.particles(other);

                % bring contact values up to the neighbors value.
                if particle.contact < neighbor.contact - 1
                    particle.contact = neighbor.contact - 1;
                end

                % the signal comes from neighbors with lower
                % contact values horizontally, and greater contact
                % values vertically.

                if neighbor.contact
                    modifier = sum(compass);
                    if modifier < 0
                        % if this is the junction between a
                        % vertical wire and a horizontal wire.
                        if particle.state == 3 & neighbor.state == 4
                            particle.signal(1) = neighbor.output;
                        else
                            particle.signal(1) = neighbor.signal(1);
                        end
                    else
                        particle.signal(2) = neighbor.signal(2);
                    end
                end

            end
        elseif particle.contact > 0 & other > 0
            neighbor = grid.particles(other);
            if neighbor.contact > 0 & not(neighbor.state == particle.state)

                % turn into the branching logic gate
                concentrations(2:3) = particle.contact * 12;

                particle.state = 4;

                motion = [0 0];
                seeking = 0;

            end
        end

    % get the signal if we are looking at an input pad.
    elseif particle.state == -orientation
            
        if particle.state == 2

            if compass(1) > 0
                particle.signal(2) = grid.input_pads(2);
            else
                particle.signal(1) = grid.input_pads(1);
            end
            
        end

    end

end

% if both ends have been joined to a wire this particle no longer
% needs to attract others.  
% if contacts == 2 & particle.state < 4
%     concentrations(particle.state) = 0;
% end

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