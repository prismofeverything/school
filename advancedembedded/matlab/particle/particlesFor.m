function particles = particlesFor(grid, group)

particles = cellfun(@(index) grid.particles{index(1), index(2)}, ...
                    group.indexes, 'UniformOutput', 0);