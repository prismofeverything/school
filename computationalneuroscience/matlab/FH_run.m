%
% FH_run.m
%
% Interface to solve the FitzHugh-Nagumo equations and plot:
%       subplot1  Voltage response and recovery response (over time)
%       subplot2)  V versus R
%
% Tamara Hayes, BME-OHSU 03/07 (modified from: Pat Roberts, 01/07)
%
clear all;

%--- Set parameters for Fitzhugh-Nagumo equations ---------------
% Wilson's values
Tau = 0.1;          % time constant of voltage response
TauR = 0.5;         % Time constant of the recovery response
a = 1.25;           % constant modifying voltage contribution to dR/dt
b = 1;              % constant modifying recovery contribution to dR/dt
c = 1.5;            % constant added to dR/dt

FH_param = [Tau TauR a b c];  % Load parameter vector

% stimulus parameters
tstop = 20;        % Duration of simulation
del = 2;          % delay in start of stimulus
dur = 5;          % duration of stimulus
I = -3.0;            % Input stimulus amplitude (modifying dV/dt)
stim_param = [del dur I];   %  Load parameter vector

%--- Compute variables -------------------------------------------
X0 = [-1.5 -3/8]';  % initial values of [V, R] : steady state with no input
[t,x] = ode23(@fhp,[0 tstop],X0,[],FH_param,stim_param);  % Runge-Kutta algorithm

%--- Plotting functions -------------------------------------------
f1=figure('Color', 'w', 'Name', sprintf('Fitzhugh-Nugamo: stimulus %5.2f (%3.1fs starting %3.1f)', I, dur,del));

% Isocline without stimulus
Xiso = -3.2:0.01:3.2;  % X  for Isoclines
Isocline1 = Xiso - Xiso.^3/3;
Isocline2 = Xiso*a + c;

% Isocline with stimulus
IsoclineS1 = Xiso - Xiso.^3/3 + I;
IsoclineS2 = Xiso*a + c;

% Plot voltage, recovery, and stimulus variables
subplot('Position', [.1 .4 .375 .55])
plot(t,x(:,1), 'b',t,x(:,2), 'r')
ylabel('V (blue), R(red)','fontsize',14)

subplot('Position', [.1 .125 .375 .175])
Ptime = 0:0.1:tstop;
stim=zeros([length(Ptime), 1]);
stim(find(Ptime>del & Ptime<del+dur))=I;
plot(Ptime, stim, 'g')
ylabel('stimulus','fontsize',14)
v=axis; 
axis([ v(1) v(2) min(stim)-0.1 max(stim)+0.1]);

% Plot the phase plane analysis
subplot('Position', [.575 .125 .375 .85])
plot(Xiso,Isocline1, 'm', Xiso,Isocline2, '--m',...
     Xiso,IsoclineS1, 'k', Xiso,IsoclineS2, '--k',...
     x(:,1),x(:,2), 'g')
ylabel('R','fontsize',14)
xlabel('V','fontsize',14)

% end % fh_run
