function gridMatrix = runSimulation(xMax, yMax, configBitstream, T)
% runSimulation - top level function for self-assembling particles.

% inputs: 
%   xMax - the maximum rows of the matrix.
%   yMax - the maximum columns of the matrix.
%   configBitstream - the configuration for the particles.  Each
%   particle has four values associated, one for each side it has
%   the potential to bind to.  If the particle moves and finds one
%   of its sides adjacent to the additive inverse, the two
%   particles will bind and move as a single unit.
%   T - the number of time steps to run the simulation.

% outputs: 
%   gridMatrix - a matrix representation of the positions of the
%   various particles as 1's, with the rest 0's.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% create a grid of the specified size.
grid = initGrid(xMax, yMax);

% populate the grid with particles corresponding to the given
% configuration bitstream.
grid = populateGrid(grid, configBitstream);

% run the simulation.
for time=1:T
    % run one timestep of the grid.
    grid = runGrid(grid);

    if (mod(time, 40) == 0)
        gridMatrix = cellfun(@(p) ~(isequal(p, [])), grid.particles);
        gridMatrix = [gridMatrix zeros(length(gridMatrix), 1)];
        gridMatrix = [gridMatrix ; zeros(1, length(gridMatrix))];
        pcolor((gridMatrix * 2) - 1);
        M(time / 40) = getframe();
    end
end

% extract the grid matrix from the particle layout.
gridMatrix = cellfun(@(p) ~(isequal(p, [])), grid.particles);

