function adjMatrix = createDirectedGraph(N, R)
% createDirectedGraph - Create a random directed adjacency matrix

% createDirectedGraph takes the number of nodes N and the number of
% edges R and returns an adjacency matrix of the corresponding
% dimension and with R total edges, including self edges and
% duplicate edges.  The adjacency matrix is represented by having
% the outgoing edges as the rows, and the incoming edges the
% columns.  The intersections [M, N] of these two show how many
% outgoing edges from M there are going to N.  In the case of
% self-edges, M=N, and for duplicate edges the value at [M N] > 1.

% inputs:
%   N - The number of nodes in the graph.
%   R - The number of edges in the graph.

% output:
%   adjMatrix - An NxN matrix representing a directed graph.

% example: 
%   graph = createDirectedGraph(5, 10)
%   graph = 
%           [ 0   0   0   1   0
%             1   0   1   0   0
%             1   0   0   0   0
%             2   0   0   0   1
%             1   1   1   1   0 ]

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% BEGIN CODE

% A random set of R 1x2 pairs with integer values in the bounds of
% the dimension of the adjacency matrix.  These pairs will be used
% as indexes to generate the adjacency matrix.
indexes = [ceil(rand(R, 2) * N)];

% This is a vector of ones to be used as the values that are
% accumulated in the various indexes of the resulting adjacency
% matrix.  Each unit corresponds to a single edge.
edges = [ones(1, R)];

% Using accumarray, for every index in the indexes vector one edge is added
% into the adjacency matrix at that index.  
adjMatrix = accumarray(indexes, edges, [N N]);

% END CODE