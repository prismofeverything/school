function state = randState(N)
% randState - Create a randomized state vector for a graph.

% The state is represented as a vector of binary values with a
% length corresponding to the number of nodes in the graph.

% inputs: 
%   N - The number of nodes in the graph.

% outputs: 
%   state - A random state a length corresponding to the number of
%   nodes in the graph.

% example: 
%   state = randState(5)
%   state = 
%           [ 1  0  1  1  0 ]

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% BEGIN CODE

% Generate a binary string of the given length N.
state = randi(2, 1, N) - 1;

% END CODE