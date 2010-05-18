function configBitstream = exampleBitstream()
% example - an example bitstream for the self-assembling particle network.

% For each of the letters the shape is not entirely deterministic.
% There are segments which are open-ended as to how many particles
% are added before a cap is put on or the next segment begun.  For
% instance, in straight lines there is often a [1 0 -1 0] pattern,
% which will link in long strands, and then a cap or corner such as
% [-1 0 0 0] or [-1 2 0 0] which ends the segment and begins a new
% one.  The length of these straight lines is not deterministic,
% but the overall shape is still representative of the letter it
% stands for.  This approach was chosen as it was discovered that
% it is much more difficult to assemble a letter which contains many
% types of tiles, so minimizing the number of types is desirable.  

% With each set of configuration corresponding to each letter,
% there is an example run that gives a good optimum of grid size
% and time steps, along with an example gridMatrix for each.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% here are some configuration tiles for R
r1 = [-8 0 8 0];
r2 = [-8 0 0 9];
r3 = [-9 0 9 0];
r4 = [-9 0 0 10];
r5 = [-10 0 10 0];
r6 = [-10 0 0 11];
r7 = [11 0 -11 0];
r8 = [-11 12 11 0];
r9 = [-12 -13 0 0];
r10 = [13 0 0 14];
r11 = [-14 -13 0 0];

rBitstream = [r1 r1 r1 r1 r1 r1 r2 r3 r3 r3 r3 r3 r4 r5 r5 r5 r6 r7 r7 r8 r9 r10 r10 r10 ...
              r11 r11 r11];

% here is an example of how to run the simulation with the R bitstream:
%   gridMatrix = runSimulation(14, 14, rBitstream, 15000);

% here is one of the R's the system generated with the above conditions:

%  0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 1 1 1 1 1 1 1 0 0 0 0
%  0 0 0 1 0 0 0 0 0 1 0 0 0 0
%  0 0 0 1 0 0 0 0 0 1 0 0 0 0
%  0 0 0 1 0 0 1 1 1 1 0 0 0 0
%  0 0 0 1 0 0 0 1 1 0 0 0 0 0
%  0 0 0 1 0 0 0 0 1 1 0 0 0 0
%  0 0 0 1 0 0 0 0 0 1 1 0 0 0
%  0 0 0 0 0 0 0 0 0 0 1 0 0 0
%  1 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0


% here are some configuration tiles for K (my middle name is Keith).
k1 = [0 -4 5 -4];
k2 = [4 0 -4 0];
k3 = [0 0 0 4];
k4 = [-5 6 0 7];
k5 = [0 -7 -6 0];
k6 = [0 7 6 0];

kBitstream = [k1 k2 k2 k2 k2 k2 k2 k3 k3 k4 k5 k5 k5 k5 k5 k5 ... 
              k6 k6 k6 k6 k6 k6];

% To run the simulation with the K bitstream:
% gridMatrix = runSimulation(15, 15, kBitstream, 10000);

% best result for K under the above conditions:

%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 1 1 1 1 1 1 1 1 1 0 0 0
%  0 0 0 0 0 1 1 1 0 0 0 0 0 0 0
%  0 0 0 0 1 1 0 1 1 0 0 0 0 0 0
%  0 0 0 1 1 0 0 0 1 0 0 0 0 0 0
%  0 0 1 1 0 0 0 0 0 0 0 0 0 0 0
%  0 0 1 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     

% here are some configuration tiles for an S.
s1 = [1 0 -1 0];
s2 = [2 -1 0 0];
s3 = [2 1 0 0];
s4 = [-2 0 3 0];
s5 = [-3 0 3 0];
s6 = [-3 0 0 15];
s7 = [-15 0 15 0];

% The configuration for S depends on the symmetricallity of the S
% shape.  For this reason some of the tiles concentrate more on one
% side of the symmetry than the other.  

sBitstream = [s1 s1 s1 s2 s3 s4 s4 s5 s5 s5 s5 s6 s6 ...
              s7 s7 s7 s7 s7 s7];

% To run the simulation with the S bitstream:
%   gridMatrix = runSimulation(11, 11, sBitstream, 10000);

% here is a good result for the S character (with a couple of stragglers):

%  0 0 0 0 0 0 0 1 1 1 0
%  0 0 0 0 0 0 0 1 0 0 0
%  0 0 0 0 0 0 0 1 0 0 0
%  0 0 0 0 0 0 0 1 1 1 0
%  0 0 0 0 0 0 0 0 0 1 0
%  0 1 1 0 0 0 0 0 0 1 0
%  0 0 0 0 0 0 0 0 0 1 0
%  0 0 0 0 0 0 0 0 0 1 0
%  0 0 0 0 0 1 1 1 1 1 0
%  0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0


% the full bitstream:
configBitstream = [rBitstream kBitstream sBitstream];

% This is an example of running the simulation with this bitstream
% and some ideal conditions:

% gridMatrix = runSimulation(19, 19, configBitstream, 40000);
