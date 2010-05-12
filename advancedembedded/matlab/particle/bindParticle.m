function grid = bindParticle(grid, index)
% bindParticle - bind particle groups adjacent to the given index.

% find the particle in question.
particle = grid.particles{index(1), index(2)};

% this is the list of opposing indexes into the configurations of
% the surrounding neighbors of this particle that will be matched
% against.
receptors = [3 4 1 2];

% these are the offsets that index into the neighbors of this
% particle.
directions = [-1  0  1  0 ; 0  1  0 -1]';

% iterate over the four cardinal directions.
for cardinal=1:4

    % get the particular modifier for this cardinal direction.
    modifier = directions(cardinal,:);

    % apply the modifier to the index to get the index of the
    % neighbor under consideration.
    target = index + modifier;

    % first check to see that the target index is inside the grid.
    if (insideGrid(grid, target))

        % if so, get the particle the target index points to.
        other = grid.particles{target(1), target(2)};

        % check to see if the target particle is empty.
        if(~isequal(other, []))

            % find the opposing bits of the two particles'
            % configuration
            self = particle.configuration(cardinal);
            opposing = other.configuration(receptors(cardinal));

            % if the configuration bits are nonzero and
            % complementary, and the two particles are not already
            % sharing a group, merge the groups.
            if ((~(opposing == 0)) & (opposing + self == 0) & ...
                ~(isequal(particle.group, other.group)))

                % remove the old groups from the grid's group list.
                newGroups = removeGroup(grid.groups, particle.group);
                newGroups = removeGroup(newGroups, other.group);

                % forge the new group by fusing the groups the two
                % particles belong to.
                uber = mergeGroups(particle.group, other.group);

                % notify all of the particles belonging to each
                % group that they are now part of a new group.
                grid = establishGroup(grid, uber);

                % add the new group to the groups list.
                grid.groups = cat(2, newGroups, uber);
            end
        end
    end
end

