function [particle, concentrations] = particleGate(particle, grid)
% particleGate - act as the gate between the three strands.


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

            if neighbor.state == 2
                inputs = inputs + 1;
                input(inputs) = neighbor.signal;
            end
        end

    end
end

% simple conversion from two-digit binary.
truth = input(1) + (2 * input(2));

% use truth as an index into the logic function.  In the case of
% 7, the result is zero only if both inputs are true, ie the 2^3
% bit is not part of the binary representation of 7.  
particle.signal = bitand(2^truth, logic) > 0;

if contacts > 2
    concentrations(2:3) = 0;
    particle.contact = 25;
end