function grid = bindParticle(grid, index)
particle = grid.particles{index(1), index(2)};
receptors = [3 4 1 2];

    function okay = checkDirection(modifier, cardinal)
    target = index + modifier;
    if (insideGrid(grid, target))
        other = grid.particles{target(1), target(2)};
        if(~isequal(other, []))
            self = particle.configuration(cardinal);
            opposing = other.configuration(receptors(cardinal));
            if ((~(opposing == 0)) & (opposing + self == 0) & ...
                ~(isequal(particle.group, other.group)))
                newGroups = removeGroup(grid.groups, particle.group);
                newGroups = removeGroup(newGroups, other.group);

                uber = mergeGroups(particle.group, other.group);

                particle.group = uber;
                grid.particles{index(1), index(2)}.group = uber;
                grid.particles{target(1), target(2)}.group = uber;
                grid.groups = cat(2, newGroups, uber);
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

