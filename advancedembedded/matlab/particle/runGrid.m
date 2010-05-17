function grid = runGrid(grid)
% runGrid - Run the given particle grid for one time step.

% In one time step, a particle group is chosen and a random
% transformation is applied.  If the transformation is valid,
% meaning it is within the grid and not overlapping another group,
% the transformation is executed and the resulting grid returned.
% Otherwise, the grid is returned unchanged.

% inputs:
%   grid - the grid to run.  

% outputs:
%   grid - the grid transformed by one time step.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

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
particles = particlesFor(grid, group);
without = gridWithout(grid, group);

% one of the six translation functions is selected to be applied to
% the chosen group.
index = randi(length(translations));
translation = translations{index};

% the chosen translation is applied and bounded.
translated = boundGroup(translation(group));

if (groupInBounds(without, translated))
    if (index == 5)
        % rotate the particles 90 degrees.
        particles = rotateParticles(particles, [-1 0]);
    end
    if (index == 6)
        % rotate the particles 270 degrees.
        particles = rotateParticles(particles, [1 0]);
    end

    % add the translated group into the grid that the pretranslated
    % group was previously removed from.
    grid = addGroup(without, translated, particles);

    % seek the new neighboring particle groups that have a
    % complementary surface and bind to them.
    grid = bindParticles(grid, translated);
end