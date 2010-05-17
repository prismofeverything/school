function particle = initParticle(configuration)
% initParticle - Create an empty particle.

% inputs: 
%   configuration - a four-element vector containing the value each
%   side of the particle will use when binding.

% outputs: 
%   particle - a new particle.

% ---------------------------------------------------
% author:  Ryan Spangler
% email:  ryan.spangler@gmail.com
% Portland State University
% -----------------------------

% The configuration specifies the particle's receptivity in each
% of the four cardinal directions, going [N E S W].  If two
% adjacent sides are inverses they link together.
particle.configuration = configuration;
