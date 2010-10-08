% Modified from (Lynch, 2004):
% Chapter 8 - Planar Systems.
% Program_8b - Phase portrait.
% Copyright Birkhauser 2004. Stephen Lynch.

% Phase portrait of a linear system of ODE's.
% IMPORTANT - Requires vectorfield.m.
clear
Input = 1
sys=inline('[10*(x(1)-(x(1)^3)/3-x(2)+1); 4*(5*x(1)/4-x(2)+3/2)/5]','t', 'x');  % Define inline function
options = odeset('RelTol',1e-4,'AbsTol',1e-4);   % set solver tolerances
[t,xa]=ode45(sys,[0 10],[-2 -2],options);       % Integrate differential equations

fsize=15;                      % set font size for graph
% ----- render x, y vs t graph  -----------
figure(1)
plot(t,xa(:,1),'r')         % plot x vs t, color red
hold on                     % retain the current plot to add more than 1 function
plot(t,xa(:,2),'b')         % plot y vs t, color red
hold off                    % release hold on current plot
legend('x(t)','y(t)')
set(gca,'xtick',[0:5:20],'FontSize',fsize)
set(gca,'ytick',[0:2:8],'FontSize',fsize)
xlabel('time','FontSize',fsize)
ylabel('x, y','FontSize',fsize)

% ----- render x vs y graph with flow field -----------
figure(2)
% warning off MATLAB:divideByZero
Xiso = -3.2:0.01:3.2;  %X for Isoclines
Isocline1 = Xiso-(Xiso.^3)/3 + Input;
Isocline2 = 5*Xiso./4+3/2;

vectorfield(sys,-3:.25:3,-3:.25:3)       % draw vector field
hold on
plot(Xiso,Isocline1)
plot(Xiso,Isocline2)
plot(xa(:,1),xa(:,2), 'k','LineWidth',2)
hold off
axis([-3 3 -3 3])       % set axis
set(gca,'xtick',[-3:1:3],'FontSize',fsize)
set(gca,'ytick',[-3:1:3],'FontSize',fsize)
xlabel('x(t)','FontSize',fsize)
ylabel('y(t)','FontSize',fsize)

% Solve isoclines simultaneously for fixed points:
%  0 = x^3/3 + 0*x^2 + x/4 + (3/2 - Input)
% Create vector of coefficients:
p = [1/3 0 1/4 3/2-Input];
% Find the roots of the polynomial:
r = roots(p);
x = r(3)
y = 5*x/4 + 3/2
hold on                     % retain the current plot to add more than 1 function
plot(x,y,'* g')         % plot x vs t, color red
hold off                    % release hold on current plot
% Jacobian
J = [10*(1-x^2)   -10
    [      1    -4/5 ]]
% Characteristic equation:
%   (J(1,1) - lambda)*(J(2,2) - lambda) - J(1,2)*J(2,1) = 0
%    lambda^2 - (J(1,1) + J(2,2))*lambda + J(1,1)*J(2,2) - J(2,1)*J(1,2)= 0
% q = [1 -(J(1,1)+J(2,2)) J(1,1)*J(2,2)-J(2,1)*J(1,2)]
% The eigenvalues of the jacobian can be found by the Matlab command eig()
evals = eig(J)
% End of Program.