function grid = establishGroup(grid, group)
% establishGroup - ensure all particles reference the same group.

    function index = establishParticle(index)
    grid.particles{index(1), index(2)}.group = group;
    end

cellfun(@establishParticle, group.indexes, 'UniformOutput', 0);

end