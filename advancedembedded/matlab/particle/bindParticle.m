function grid = bindParticle(grid, index)
particle = grid.particles(index(1), index(2))
receptors = [3 4 1 2];

    function okay = checkDirection(modifier, cardinal)
    index
    modifier
    target = index + modifier;
    if (insideGrid(grid, target))
        other = grid.particles(target(1), target(2))
        if(~isequal(other, {[]}))
            self = particle{1}.configuration(cardinal)
            opposing = other{1}.configuration(receptors(cardinal))
            if ((~(opposing == 0)) & (opposing + self == 0) & ...
                ~(isequal(particle{1}.group, other{1}.group)))
                uber = mergeGroups(particle{1}.group, other{1}.group)
                particle{1}.group = uber;
                other{1}.group = uber;
            end
        end
    end
    end

directions = [-1  0  1  0 ; 0  1  0 -1]';
arrayfun(@(row) checkDirection(directions(row,:), row), 1:4) 

% % % this way is too expensive...
% directions = arrayfun(@(theta) [int8(-cos(theta)), int8(sin(theta))], ...
%                       0:pi*0.5: pi*1.5, 'UniformOutput', 0);

end

