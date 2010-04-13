function visualizeGraph(adjMatrix, posMatrix)
% visualizeGraph - A function that plots a graph given the
% adjacency matrix and a matrix of positions for the various nodes.

% inputs:
%   adjMatrix - A square matrix whose entries correspond to edges
%       between nodes.
%   posMatrix - The points on the graph to place the nodes to be visualized.

% example:
%   adjMatrix = createGraph(5, 10)
%   posMatrix = randint(2, 5, [1 10])
%   visualizeGraph(adjMatrix, posMatrix)

% use gplot with blue lines
gplot(adjMatrix, posMatrix, '-ob')