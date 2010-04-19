% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

adjMatrix = createDirectedGraph(5, 10);

% adjMatrix = 
%            1     0     1     1     0
%            1     0     0     0     0
%            0     1     0     0     0
%            0     0     0     0     1
%            1     2     0     0     1

state = randState(5);

% state = 
%        1     0     0     0     1

history = state;
for step=1:10
    state = evolveState(adjMatrix, state);
    history = vertcat(history, state);
end

% Each column in history represents a node in the graph through
% time, with earlier times above later ones.

history

% history =
%      1     0     0     0     1   --- Initial State
%      0     1     0     0     0   --- 10 steps
%      0     1     1     1     1          .
%      1     1     1     1     0          .
%      0     0     0     0     0          .
%      1     1     1     1     1          .
%      1     1     0     0     0          .
%      0     1     0     0     1          .
%      1     1     1     1     0          .
%      0     0     0     0     0          .
%      1     1     1     1     1          .