function translation = translateGroup(vector)
% translateGroup - given a vector, return a function that
% translates a group according to that vector.

% inputs:
%   vector - the vector to translate every particle in the group
%   by.

% outputs:
%   translation - a function which represents a translation by the
%   given vector.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

    % define a function that translates a given group along a
    % transformation defined by the original vector.
    function group = translate(group)
        % simply add the vector to each index.
        group.indexes = cellfun(@(index) index + vector, group.indexes, ...
                                'UniformOutput', 0);
    end

    % return a handle to the newly created function.
    translation = @translate;
end