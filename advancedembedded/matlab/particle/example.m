function gridMatrix = example()
% example - an example for the self-assembling particle network.

% this is a top-level file used to run the example bitstream under
% ideal size and time conditions.

% inputs:
%   none

% outputs:
%   gridMatrix - a matrix containing 1's and 0's corresponding to
%   the positions of the particles within the grid.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% retrieve the example bitstream.
configBitstream = exampleBitstream();

% run the simulation with the full bitstream.
gridMatrix = runSimulation(19, 19, configBitstream, 40000);
