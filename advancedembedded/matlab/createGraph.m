function adjMatrix = createGraph(N, R)
% createGraph - Create an NxN adjacency matrix with R unique edges.

% inputs:
%   N - The number of nodes in the graph.
%   R - The number of edges in the graph.  Each edge counts as
%       going in one direction, so there are two for every
%       undirected edge.

% output:
%   adjMatrix - A random undirected adjacency matrix with N rows 
%       and N columns.

% example:
%   createGraph(5, 10) - yields an 5x5 adjancency matrix with 10/2
%       = 5 directed edges (or 10 directed, symmetrical edges)

% BEGIN CODE

% The general strategy here is to focus only on the elements in the
% lower triangle of the matrix below the diagonal as potential
% candidates to create an edge.  Then once R/2 edges have been 
% created, add the matrix to its transpose, creating a symmetric 
% adjacency matrix representing an undirected graph.   

% Find the number of elements in the lower triangle, using the
% formula for triangular numbers.
triangle = @(dim) ((dim - 1) * dim) / 2;

% Find the triangle root of a given number (the inverse of
% triangle operation defined above).
triangle_root = @(tri) ((sqrt(8 * tri + 1) - 1) / 2);

% Find the base of the triangle root to be used as row index into
% the adjacency matrix when translating triangular coordinates to
% matrix coordinates.
root_base = @(choice) floor(triangle_root(choice-1)) + 1;

% Permute a list of length triangle and choose the first R/2
% elements from it.  Since these are permuted elements of a range
% they are guaranteed unique.  These chosen elements will act as 
% indexes into the lower triangle of the adjacency matrix.
permuted = randperm(triangle(N));
chosen = permuted(1:R/2);

% fix_root takes the triangle root precalculated from detriangle
% below, so that the computation done by root_base does not have to
% happen twice.
fix_root = @(choice, root) [root + 1; mod(choice, root) + 1];

% The detriangle function translates from a linear scalar index
% into the triangle into a 1x2 index into the adjacency matrix.
detriangle = @(choice) fix_root(choice, root_base(choice));

% Detriangle the chosen indexes to get the 1x2 indexes into the
% adjacency matrix.
indexes = [detriangle(chosen)]';

% Represent the edges as a list of R/2 ones.
edges = [ones(1, R/2)];

% Accumulate the edges at the chosen indexes.
base = accumarray(indexes, edges, [N N]);

% We add the base to its transpose to make the upper triangle a
% reflection of the lower one about the empty diagonal, creating a
% symmetric matrix which ensures the adjacency matrix is undirected.
adjMatrix = base + base';

% END CODE