function grid = example()
% example - provide an example of running the particle system.

% This function creates a grid and runs it for 100 timesteps, also
% showing an animation of the system assembling itself.  Once the
% grid has been created and returned, you can examine or change the
% inputs and outputs through grid.input_pads and grid.output_pad.

% To run the grid as a circuit once it has had some time to
% establish a circuit, give the grid along with some input values
% to the runCircuit function like so:

% runCircuit(grid, 0, 0)  =>  should output 1
% runCircuit(grid, 0, 1)  =>  should output 1
% runCircuit(grid, 1, 0)  =>  should output 1
% runCircuit(grid, 1, 1)  =>  should output 0

% Most of the explanation for the various components is in
% initGrid.m and initParticle.m.  The process for how the system
% behaves is detailed in the three particle state functions, particleSeek.m,
% particleGrow.m and particleGate.m.  Please refer to these files
% for further information.

% outputs:
%   grid - a new grid run through 100 timesteps.

% BEGIN CODE

% 100 time steps is usually enough to establish a circuit, but not always.
grid = runSimulation(100);

% END CODE