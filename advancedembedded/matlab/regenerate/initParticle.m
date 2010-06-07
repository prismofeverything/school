function particle = initParticle(position, behavior)
% initParticle - create a particle at the given location.

% The particle is the basic unit of the system.  

% A particle can only influence the concentration of the cell it is
% currently occupied, and has no control over the concentration in
% neighboring cells, even though it can sense the concentration
% from neighboring cells.

% inputs: 
%   position - The position the particle occupies in the grid.
%   behavior - This function governs the particle's behavior in response to
%   concentrations and the presence of neighbors or defects.  
%
%   The behavior is a function of the form:
%
%   function [motion, concentration, state, contact] = behavior(particle, grid)
%
%   inputs:
%     particle - the particle under consideration.
%     grid - the grid the particle resides under.  The grid may not
%     be consulted without bounds!  Each particle may take under
%     consideration only its four neighbors along with its own
%     cell.  The passing of the entire grid simplifies the process
%     of calling these behaviors.
%     
%   outputs:
%     motion - the motion resulting from the behavior.  It must be
%     one of [[-1 0] [0 1] [1 0] [0 -1]].
%     concentration - the concentration signal the particle is
%     leaving behind in this space.  The particle can set the
%     concentration to any value immediately, it is not constrained
%     to simply incrementing or decrementing it.
%     state - the state resulting from this behavior.  Since the
%     states refer to behaviors and the behaviors determine the
%     subsequent states this system forms a closed loop resembling
%     a finite state automata.
%     contact - contact is a value of how long the thread is that
%     this particle is connected to which is ultimately connected
%     to an input or output pad.  If this particle is not
%     participating in such a thread, its contact value is 0.  The
%     immediate particle adjacent to an I/O pad has a contact value
%     of 1, and subsequent connections have an increasing contact
%     value.  This contact value determines the degree to which a
%     thread of particles has managed to grow, with longer threads
%     depositing a higher concentration resulting in the attraction
%     of unassociated particles.

% outputs: 
%   particle - A newly created particle. 


% BEGIN CODE

% The particles position within the grid.
particle.position = position;

% Once a particle is set in motion, it retains an inertia which
% sends it along a particular direction unless another force
% counteracts that inertia.
particle.inertia = [0 0];

% The particle's state is a number that represents which behavior
% state the particle is in.  Though the behavior is stored in
% particle.behavior, each value of particle.state corresponds to
% exactly one of the possible particle.behaviors and vice versa.
% This value is present to give neighboring particles the ability
% to modulate their behavior based on what state this particle is in.
particle.state = 1;

% the behavior function as described above.
particle.behavior = behavior;

% contact represents whether or not this particle is connected
% ultimately to one of the input or output pads.  The value is
% stored as the length of the strand this particle is
% a part of, if it has found a strand yet, and zero if it is unconnected.
particle.contact = 0;

% If a particle is in contact, the signal represents the state that
% is propagated along the particle strand.  If this particle lies
% along an input strand, the signal is the input value as detected
% by the particle that is actually in contact with the input pad.
% If the particle lies along an output strand, it will be in
% contact with the output pad, and propagate its signal that way.
% If the particle is at a junction between three strands it forms
% the logic gate, and performs whatever logical operation depends
% upon the two input strands, and sends that signal to the output strand.
particle.signal = [-1 -1];

% A particle can in its lifetime fail, becoming a fault.  This is
% signified by setting particle.intact = 0.  A faulty particle will
% not appear in the particle grid or take part in any particle activities.
particle.intact = 1;

% END CODE