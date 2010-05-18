function gridMatrix = example()
% example - an example for the self-assembling particle network.

% this is a top-level file used to run the example bitstream under
% ideal size and time conditions.  Consult exampleBitstream.m for
% examples of the bitstreams for each letter, as well as sample
% runs for each letter.

% inputs:
%   none

% outputs:
%   gridMatrix - a matrix containing 1's and 0's corresponding to
%   the positions of the particles within the grid after the
%   simulation has finished running.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% retrieve the example bitstream.  
configBitstream = exampleBitstream();

% run the simulation with the full bitstream.  visualizeSimulation
% will use pcolor to display the matrix as a grid of red and blue
% rectangles.  To run without the visualization, just use runSimulation.
gridMatrix = visualizeSimulation(16, 16, configBitstream, 20000);

% The results are not entirely ideal.  Though I was able to attain
% good results for each letter individually, a collection of all
% three has proven difficult to attain, as the particles do not
% seem to meet their matching components as often in the larger
% space.  Even though doubling the time seems to help somewhat, the
% letters still remain not fully formed.  Given an indefinite
% period of time I am certain the letters would form, as they form
% individually, but the runs already take quite a bit of time with
% 40000 steps, so I have not extended it beyond this.

% Regardless, in exampleBitstream.m there are examples of each
% bitstream on its own, and the resulting gridMatrix for each one.