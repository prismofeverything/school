function output = runCircuit(grid, inputA, inputB)
% runCircuit - run the given grid as a circuit.

% Once the grid has been given some time to get the circuit
% established, runCircuit can be used to treat the entire system as
% a logical operation.  This system implements a NAND gate.

% inputs:
%   grid - the grid with an established circuit on board.
%   inputA - the first input to the logical function.
%   inputB - the second input to the logical function.

% outputs:
%   output - the result of applying the logical function through
%   the particles to the given set of input values.

% BEGIN CODE

% assign the input pads for the grid.
grid.input_pads = [inputA, inputB];

for i=1:12
    % run the grid 12 times.
    grid = runGrid(grid);
end

% return the resulting value of the grid's output pad.
output = grid.output_pad;

% END CODE