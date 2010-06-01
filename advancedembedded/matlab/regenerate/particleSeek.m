function [motion, concentration, state, contact] = particleSeek(particle, grid)
% particleSeek - given the set of neighbors, find the next motion.

% There are a number of functions a particle must perform as it is
% yet unbound and undifferentiated.  First, it is looking for
% defects, and if found, notifying others of them.  Completing the
% bands where it is unsafe to build due to being in line with a
% defect is one of the first things that should happen.  Next, if it
% is next to a gradient that is more than one larger than the
% gradient on which it resides, it updates its gradient to be one
% lower than the gradient it found.  This is in line with the idea
% that a particle may only affect the concentration gradient in the
% cell in which it resides.  If it finds a particle which is
% emitting a gradient it will attach, and change state into an
% emitting particle, attracting others to bind to it.  

% inputs:
%   neighbors - A list of neighboring particles 

% outputs:
%   motion - a two-element vector containing the next direction the
%   particle will take.  Since it can only move horizontally or
%   vertically, only one component may be nonzero at a time.  No
%   motion is represented as [0 0], up as [-1 0], right as [0 1]
%   etc.


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
motion = compassDirections(:, randi(4))';

% initialize the state to the particle's current state.
state = particle.state;

% whether or not the particle attains contact with a pad.
contact = 0;

% give distinct signals for defects along the horizontal and
% vertical axes.
defectSignals = [-2 -3];

% can be set to 0 to terminate processing by this particle.
seeking = 1;

% iterate through the four compass directions.
for compass=compassDirections

    % if we are still deciding what to do...
    if seeking

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
            
            % find if this grid cell is a defect or in a defect band.
            if (surroundingConcentration == -1 | ...
                surroundingConcentration == defectOrientation) & ...
                    not(homeConcentration == defectOrientation)

                % This condition overrides any other discovery, so
                % terminate the search process and return the new
                % signal concentration, state and motion direction (away from
                % the defect, to spread the warning).
                concentration = defectOrientation;
                motion = -compass';
                state = 1;
                seeking = 0;

            % otherwise, if we are next to a particle that is in
            % contact with an input or output pad, affix to it and
            % take on the role of the terminal of the strand.
            elseif other > 0 & grid.particles(other).state == -defectOrientation

                % choose the state to align with whether the
                % neighboring particle is horizontal or vertical.
                state = -defectOrientation;

                % stop moving.
                motion = [0 0];

                % adopt a contact value one greater than the neighbor.
                contact = grid.particles(other).contact + 1;

                % emit a concentration proportional to the length of
                % the strand.
                concentration = contact + 1;

            % otherwise see if there is a concentration gradient to follow.
            elseif surroundingConcentration - 1 > concentration

                % if so, seek the highest point and mark the current
                % position with one concentration level lower.
                concentration = surroundingConcentration - 1;
                motion = compass';
            end

        % Otherwise there lies outside of the grid.  
        else

            % determine if the particle is at an input or output
            % pad.  The only side that is not significant is the
            % left side, whereas the top and bottom are inputs and
            % the right side is an output.
            if there(2) >= 1

                % bind to the pad by changing to a beacon state and
                % starting a fledgling gradient.
                state = -defectOrientation;
                motion = [0 0];
                contact = 1;
                concentration = 2;

            end                

            % continue seeking in case this is actually a toxic
            % zone along the band of a defect, where the particle
            % will have to vacate anyway.

        end
    end

    % find the ultimate location that the resulting motion implies.
    going_into = particle.position + motion;

    % if it lies outside of the grid or is occupied by another
    % particle or a fault, motion is not possible that way.
    if not(inBounds(grid, going_into)) | not( ...
            grid.particleMatrix(going_into(1), going_into(2)) == 0)
        motion = [0 0];
    end
end

% END CODE