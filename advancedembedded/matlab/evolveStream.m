function state = evolveStream(adjMatrix, state)
% evolveState - Evolve the state of the graph based on a logical function.

% Given an adjancency matrix representing the connectivity of a
% graph and a vector of binary digits corresponding to the state of each
% node in the graph, calculate the state that results from applying
% the given logical function to each node taking the state of its
% incoming edges as inputs.  

% As it is coded, evolveState has a hard-coded logical function F
% that each node executes.  However, this function is implemented
% as a vector of binary values representing the truth table for an
% arbitrary logical function.  In this way, any logical function
% could be encoded by supplying a different binary vector, with the
% one present simply an arbitrary choice.  This flexibility could
% be taken advantage of if evolveState were also to take a truth
% table as a third argument, but due to the limitations of the
% assigment, is content to be hard-coded.

% inputs:
%   adjMatrix - A matrix representing the edges in a graph.  The
%     edges going out of a node are a row, with each node the edge or
%     edges are going to being the column for that row.  
%   state - a vector of binary digits representing the state of
%     each node in the graph.

% output: 
%   state - the state as resulting from applying the logical
%     function to the values of the nodes for the incoming edges.  

% example: 
%   graph = createDirectedGraph(5, 10)
%   state = randState(5)
%   state = evolveState(graph, state)

%   state = 
%           [ 1 1 1 1 0 ]     (or similar) 

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% BEGIN CODE

    function unfolded = unfoldBinary(column)
        function flat = binaryChain(bit, level, span)
        if (span > 0)
            chain = (0:span-1) + level;
            flat = bit * sum(2.^chain);
        else
            flat = 0;
        end
        end

    unfolded = arrayfun(@binaryChain, state, cumsum(column), column);
    end

truth = 

inputs = arrayfun(@(n) bitand(truth, 2^unfoldBinary(adjMatrix(:, n))), ...
                  1:length(state));

end

% END CODE 