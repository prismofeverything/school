function adjMatrix = createDirectedGraph(N, R)
% createDirectedGraph - Create a random directed adjacency matrix

% createDirectedGraph takes the number of nodes N and the number of
% edges R and returns an adjacency matrix of the corresponding
% dimension and with R total edges, including self edges and
% duplicate edges.

% inputs:
%   N - The number of nodes in the graph.
%   R - The number of edges in the graph.

% output:
%   adjMatrix - An NxN matrix representing a directed graph.

indexes = [ceil(rand(R, 2) * N)]
units = [ones(1, R)]
adjMatrix = accumarray([indexes; [5, 5]], [units, 0])

