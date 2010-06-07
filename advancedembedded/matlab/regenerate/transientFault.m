function grid = transientFault(grid, chosen)
% transientFault - remove the chosen particle from the grid.


grid.particles(chosen).intact = 0;
fault = grid.particles(chosen);
grid.particleMatrix(fault.position(1), fault.position(2)) = 0;
grid.concentrations(fault.position(1), fault.position(2), 2:3) = 0;

