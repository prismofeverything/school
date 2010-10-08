%
% hh_integrate.m
%
% Integrate the Hodgkin Huxley equations
%     Function takes parameters from the interface and uses an ODE
%     integrator to solve the nested equations. 
%
% PD Roberts, BME-OHSU 01/07 (modified from: Steve Cox, 1/17/03)
%
function [t,x] = hh_integrate(t, hh_param, stim_param)

X0 = [-65 0.318 0.053 0.595]';  % initial valuse of [v n m h]
[t,x] = ode23(@hhp,[0 t],X0);  % Runge-Kutta algorithm

%=== begin nested functions ====

% Set up the Hodgkin-Huxley equations 
% Dynamic variables are stored in X = [v n m h]'

%--- Hodgkin-Huxley equations voltage equation, pp 173 of [Dayan01] ---
function dXdt = hhp(t,X)

    dXdt = zeros(4,1);

    GNa = hh_param(1);  
    GK = hh_param(2);    
    Gl = hh_param(3);   
    vNa = hh_param(4); 
    vK = hh_param(5);
    vl = hh_param(6);
    Cm = 1;              % capacitance density (uF / cm^2)
    A = 1.26e-5;	 % membrane area (A=4*PI*R^2, R=10u, cm^2)
 
    %  stimulus is current injection
    I = 0;
    if (t>=stim_param(1) & t<=stim_param(1)+stim_param(2))
       I = stim_param(3)/1000;  % parameter in nA
    end

    % right hand sides of HH equations (26),(7),(15),(16) of [Hodgkin52]

    dXdt(1) = (1/Cm)*(-GK*(X(2)^4)*(X(1)-vK) + ...
           -GNa*(X(3)^3)*X(4)*(X(1)-vNa) - Gl*(X(1)-vl) + I/A);

    dXdt(2) = an(X(1))*(1-X(2)) - bn(X(1))*X(2);

    dXdt(3) = am(X(1))*(1-X(3)) - bm(X(1))*X(3);

    dXdt(4) = ah(X(1))*(1-X(4)) - bh(X(1))*X(4);

    return
end % hhp

%--- Voltage dependent rate functions from  pp 171-172 of [Dayan01] ---

function val = an(v)  % opening rate functions of potassium activation
    val = 0.01*(v+55)/(1-exp(-0.1*(v+55)));
end

function val = bn(v)  % closing rate functions of potassium activation
    val = 0.125*exp(-0.0125*(v+65));
end

function val = am(v)  % opening rate functions of sodium activation
    val = .1*(v+40)/(1-exp(-.1*(v+40)));
end

function val = bm(v)  % closing rate functions of sodium activation
    val = 4*exp(-0.0556*(v+65));
end

function val = ah(v)  % opening rate functions of sodium inactivation
    val = 0.07*exp(-0.05*(v+65));
end

function val = bh(v)  % closing rate functions of sodium inactivation
    val = 1/(1+exp(-0.1*(v+35)));
end

%=== end nested functions ===
end % hh_integrate
