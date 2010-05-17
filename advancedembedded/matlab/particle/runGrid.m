function grid = runGrid(grid)
% runGrid - Run the given particle grid for one time step.

% a vector representing the four cardinal directions.
directions = [-1  0  1  0 ; 0  1  0 -1]';

% create a translation function for each of the four directions up,
% down, left and right.
for dir=1:4
    translations{dir} = translateGroup(directions(dir,:));
end
% add the rotations to the list of possible translations.
translations{5} = @rotateGroup90;
translations{6} = @rotateGroup270;

% a random group index is chosen.
chosen = randi(length(grid.groups));

% the chosen group is extracted from the grid
group = grid.groups{chosen};
particles = particlesFor(grid, group)
without = gridWithout(grid, group);

% one of the six translation functions is selected to be applied to
% the chosen group.
index = randi(length(translations))
translation = translations{index};

% the chosen translation is applied and bounded.
translated = boundGroup(translation(group));

if (groupInBounds(without, translated))
    if (index == 5)
        % rotate the particles 90 degrees.
        particles = rotateParticles(particles, [-1 0])
    end
    if (index == 6)
        % rotate the particles 270 degrees.
        particles = rotateParticles(particles, [1 0])
    end

    grid = addGroup(without, translated, particles);
end