function [particle, concentrations] = particleGate(particle, grid)
% particleGate - act as the gate between the three strands.

% When two perpendicular wires meet, the particle at the hub
% transitions into the GATE state.  It elevates its contact level
% to the maximum possible value, letting the lower values propagate
% down the wires, establishing the orientation of the wires and the
% direction of signal flow.

% It then reads the signal values of the two inputs and attains the
% signal state of applying the gate's logical function.  This
% signal state is later read by the particle at the base of the
% output wire, and propagates down the wire towards the output pad.

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

% number of inputs found.
inputs = 0;

% actual input and output signals for the logic gate.
input = [0 0];
output = 0;

% 7 represents NAND
logic = 7;

gating = 1;

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

            % find the neighboring particle.
            neighbor = grid.particles(other);

            if neighbor.contact > 0
                contacts = contacts + 1;

                if neighbor.state == 2 
                    modifier = sum(compass);

                    if modifier > 0 & neighbor.signal(1) >= 0 
                        inputs = inputs + 1;
                        input(inputs) = neighbor.signal(1);
                    elseif modifier < 0 & neighbor.signal(2) >= 0
                        inputs = inputs + 1;
                        input(inputs) = neighbor.signal(2);
                    end

                end
            end

        end

    end

end

% simple conversion from two-digit binary.
truth = input(1) + (2 * input(2));

% use truth as an index into the logic function.  In the case of
% 7, the result is zero only if both inputs are true, ie the 2^3
% bit is not part of the binary representation of 7.  
if inputs == 2
    particle.signal(1) = bitand(2^truth, logic) > 0;
    concentrations(2:3) = 0;
    particle.contact = 25;
end

