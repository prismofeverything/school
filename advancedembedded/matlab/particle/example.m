function gridMatrix = example()
% example - an example for the self-assembling particle network.

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
r12 = [-14 0 0 0];

rBitstream = [r1 r1 r1 r1 r1 r1 r1 r1 r2 r3 r3 r3 r3 r3 r4 r5 r5 r5 r6 r7 r7 r7 r8 r9 r10 r10 r10 ...
              r10 r10 r11 r11 r11 r11 r11 r12];

% run the simulation with the R bitstream.
gridMatrix = runSimulation(15, 15, rBitstream, 40000);

% here are some configuration tiles for K (my middle name is Keith).
k1 = [0 -4 5 -4];
k2 = [4 0 -4 0];
k3 = [0 0 0 4];
k4 = [-5 6 0 7];
k5 = [0 -7 -6 0];
k6 = [0 7 6 0];
k7 = [0 -7 0 0];

kBitstream = [k1 k2 k2 k2 k2 k2 k2 k3 k3 k4 k5 k5 k5 k5 k5 k5 ... 
              k5 k5 k6 k6 k6 k6 k6 k6 k6 k6 k7 k7];

% run the simulation with the K bitstream.
% gridMatrix = runSimulation(15, 15, kBitstream, 20000);

% best result for K under the above conditions:

%  0 0 0 0 0 0 1 0 0 0 0 0 0 0 0
%  0 0 0 0 0 1 1 0 0 0 0 0 0 0 0
%  0 0 0 0 1 1 0 0 0 0 0 0 0 0 0
%  0 0 0 1 1 0 0 0 0 0 0 1 1 0 0
%  0 0 0 0 0 0 0 0 0 0 1 1 0 0 0
%  0 0 0 0 0 0 0 0 1 1 1 0 0 0 0
%  0 0 0 0 0 0 0 0 1 1 0 0 0 0 0
%  0 0 0 0 0 0 0 0 1 1 1 0 0 0 0
%  0 0 0 0 0 0 0 0 1 0 1 1 0 0 0
%  0 0 0 0 0 0 0 0 1 0 0 1 0 0 0
%  0 0 0 0 0 0 0 0 1 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 1 1 1 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     
% Unfortunately the last straight piece did not connect with the
% top of the K.

%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 1 1 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 1 1 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 1 1 0 0
%  0 0 0 0 1 1 1 1 1 1 1 1 1 0 0
%  0 0 0 0 0 0 1 1 0 0 0 0 0 0 0
%  0 0 0 0 0 1 1 0 0 0 0 0 0 0 0
%  0 0 0 0 1 1 0 0 0 0 0 0 0 0 0
%  0 0 0 1 1 0 0 0 0 0 0 0 0 0 0
%  0 0 1 1 0 0 0 0 0 0 0 0 0 0 0
%  0 1 1 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0



% here are some configuration tiles for an S.
s1 = [1 0 -1 0];
s2 = [2 -1 0 0];
s3 = [2 1 0 0];
s4 = [2 0 -2 0];
s5 = [-2 0 0 3];
s6 = [-3 0 3 0];
s7 = [-3 0 0 0];

sBitstream = [s1 s1 s1 s1 s1 s2 s3 s4 s4 s4 s4 s4 s4 s4 s4 s5 s5 ...
              s6 s6 s6 s6 s6 s6 s6 s6 s7 s7];

% run the simulation with the S bitstream.
% gridMatrix = runSimulation(15, 15, sBitstream, 20000);

% best result with this tile set and grid size:

%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 1 1 1 1 1 1 1 1 1 1 0 0
%  0 0 0 1 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 1 0 0 0 0 0 0 0 0 0 0 0
%  0 0 0 1 1 1 1 1 1 1 0 0 0 0 0
%  0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
%  0 0 0 0 0 0 0 0 1 1 0 0 0 0 0

% Notice the tiny but present curve at the bottom.  The straight
% piece on top never quite made the connection with it.
 
