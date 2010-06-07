function grid = initGrid(rows, columns, behaviors)
% initGrid - create an empty grid to house the particles.

% The grid has cells which represent the presence of concentrations
% of various signals in the medium.  These can be sensed by
% surrounding particles which inform their decision about which
% cell to move to next, or to stay in the cell they are in.  In
% addition, each cell keeps track of the index of whatever particle
% occupies it.  

% A -1 in the particle matrix also
% denotes a fault, and a 0 signifies that the cell is empty.  Any
% other number is the index of the particle in grid.particles where
% the particle occupying this cell resides.

% inputs:
%   rows - the number of rows.
%   columns - the number of columns.
%   behaviors - A cell array of functions which represent the
%   behavior of the system.  All particles start out with behavior
%   1, corresponding to state 1.  The behaviors themselves are
%   functions of the form:
%
%     function [motion, concentration, state, contact] =
%     behavior(particle, grid)
%
%   See particle.m for more details on the arguments and outputs of
%   this class of function.

% outputs:
%   grid - The newly initialized grid.
     
% BEGIN CODE

defectRate = 0.02;

% The dimensions of the grid.
grid.rows = rows;
grid.columns = columns;

% we assume at the beginning that the input and output pads are 0.
% The input pads influence any particle attached to the top or
% bottom respectively, and the output pad is triggered by a signal
% coming from a particle fed into the right side.
grid.input_pads = [0 0];
grid.output_pad = 0;

% The concentrations of the grid represent the presence of the
% particle's signaling medium, analogous to a chemical gradient or
% radio signal used by coordinating elements.  There is only one
% kind of signal, though different values signify different things.

% A concentration of 0 means that the given cell is empty.
% A concentration level of -1 denotes a defect in the grid, present
% from the outset of the grid.  
% A concentration level of -2 or -3 is a particle's signal to other
% particles that this row or column, respectively, contains a
% defect, and should be avoided for building connections.
% A positive concentration level signified the concentration of the
% signaling medium, higher levels being more attractive than lower
% ones.  The signals emerge from particles who possess a connection
% to an input or output pad and are searching for a connection to
% the rest of the circuit.  Unconnected particles will follow the
% concentration gradient in search of a budding circuit to join.
grid.concentrations = zeros(rows, columns, 5);

% The particle matrix is a matrix containing indexes to the
% particle that occupies that cell in the grid.  Since each
% particle also keeps track of its position, the particle can be
% retrieved given its position in the grid or the information about
% that position can be obtained from the particle, creating a
% two-way informational pathway.
grid.particleMatrix = zeros(rows, columns);
grid.stateMatrix = zeros(rows, columns);

% The total number of defects in the grid, before the defect
% probability has been applied.
grid.defects = 0;

% The set of behaviors map to the set of possible states the
% particles can be in at any given time step.  The state
% enumeration and behavior identity mapping is one to one.  
grid.behaviors = behaviors;

% iterate through each cell and assign it as a defect according to
% the defectRate.
for row=1:rows
    for column=1:columns
        if (rand(1) < defectRate)
            grid.concentrations(row, column, 4:5) = [-1 -1];
            grid.particleMatrix(row, column) = -1;
            grid.stateMatrix(row, column) = -1;
            grid.defects = grid.defects + 1;
        end
    end
end

% END CODE