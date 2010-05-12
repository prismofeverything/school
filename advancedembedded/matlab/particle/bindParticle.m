function grid = bindParticle(grid, index)

    function okay = checkDirection(modifier)
    target = index + modifier;
    particle = grid(target(1), target(2));
    if (outsideGrid(target))
        return 0;
    elseif 
        
    end
    end

receptors = [3 4 1 2];
directions = [-1  0  1  0 ; 0  1  0 -1];

% % % this way is too expensive...
% directions = arrayfun(@(theta) [int8(-cos(theta)), int8(sin(theta))], ...
%                       0:pi*0.5: pi*1.5, 'UniformOutput', 0);



