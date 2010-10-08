%
% hh_run.m
%
% Interface to solve the HH equations and plot:
%       figure(1)  v, n, m and h
%       figure(2)  v, I_Na, I_K and I_l
%
% PD Roberts, BME-OHSU 01/07 (modified from: Steve Cox, 1/17/03)
%
clear all;

%--- Set model parameters -------------------------------------
tstop = 20;  % Duration of simulation (msec)

% parameters for Hodgkin-Huxley equations (from table 3 of [Hodgkin53])
GNa = 120;           % Maximum sodium current density (mS / cm^2)
GK = 36;             % Maximum potassium current density (mS / cm^2)
Gl = 0.3;            % Leak current density (mS / cm^2)
vNa = 50;            % Reversal potential for sodium current (mV)
vK = -77;            % Reversal potential for potassium current (mV)
vl = -54.3;          % Reversal potential for leak current (mV)
HH_param = [GNa GK Gl vNa vK vl];  % Load parameter vector

% stimulus parameters
del = 5;             % Delay until beginning of stimulus (msec)
dur = 1;            % Duration of stimulus (msec)
amp = 0.1;           % Amplitude of stimulus (nA)
stim_param = [del dur amp];  % Load parameter vector

%--- Compute variables -------------------------------------------
[t,x] = hh_integrate(tstop, HH_param, stim_param);  % Call integrator function  

INa = GNa*(x(:,3).^3).*x(:,4).*(x(:,1)-vNa); % Sodium current for plot
IK = GK*(x(:,2).^4).*(x(:,1)-vK);   % Potassium current for plot
Il = Gl*(x(:,1)-vl);                % Leak current for plot

%--- Plotting functions -------------------------------------------
figure(1)       % Plot membrane potential and activation variables
subplot(2,2,1)
plot(t,x(:,1), 'k')
ylabel('v (mV)','fontsize',16)
subplot(2,2,2)
plot(t,x(:,2), 'r')
ylabel('n','fontsize',16)
subplot(2,2,3)
plot(t,x(:,3), 'b')
xlabel('t (ms)','fontsize',16)
ylabel('m','fontsize',16)
subplot(2,2,4)
plot(t,x(:,4), 'g')
xlabel('t (ms)','fontsize',16)
ylabel('h','fontsize',16)

figure(2)       % Plot membrane potential and currents
subplot(2,2,1)
plot(t,x(:,1), 'k')
ylabel('v (mV)','fontsize',16)
subplot(2,2,2)
plot(t,INa, 'r')
ylabel('I_{Na}','fontsize',16)
subplot(2,2,3)
plot(t,IK, 'b')
xlabel('t (ms)','fontsize',16)
ylabel('I_K','fontsize',16)
subplot(2,2,4)
plot(t,Il, 'y')
xlabel('t (ms)','fontsize',16)
ylabel('I_l','fontsize',16)
