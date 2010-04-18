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

% A random set of R 1x2 pairs with integer values in the bounds of
% the dimension of the adjacency matrix.  These pairs will be used
% as indexes to generate the adjacency matrix.
indexes = [ceil(rand(R, 2) * N)]

% This is a vector of ones to be used as the values that are
% accumulated in the various indexes of the resulting adjacency
% matrix.  Each unit corresponds to a single edge.
edges = [ones(1, R)]

% Using accumarray, for every index in the indexes vector one edge is added
% into the adjacency matrix at that index.  An [N, N] index is
% added to the end of the indexes vector and mapped to zero to
% ensure that there will always be a full NxN resultant matrix
% from accumarray.
adjMatrix = accumarray([indexes; [N, N]], [edges, 0])

