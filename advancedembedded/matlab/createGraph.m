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
triangle = ((N - 1) * N) / 2;

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
permuted = randperm(triangle);
chosen = permuted(1:R/2);

% Create an empty NxN matrix.
base = zeros(N);

% Translate linear index for lower triangle into a row and column
% to index the adjacency matrix and assign the chosen cell to 1.
for choice = chosen
    root = root_base(choice);
    base(root + 1, mod(choice, root) + 1) = 1;
end

% We add the base to its transpose to make the upper triangle a
% reflection of the lower one about the empty diagonal, creating a
% symmetric matrix which ensures the adjacency matrix is undirected.
adjMatrix = base + base';

% END CODE