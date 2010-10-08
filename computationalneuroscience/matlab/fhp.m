% Set up the Fitzhugh equations
% Dynamic variables are stored in X = [V R]'
function dXdt = fhp(t,X,hh_param,stim_param)
    dXdt = zeros(2,1);
    Tau = hh_param(1);  
    TauR = hh_param(2);    
    a = hh_param(3);   
    b = hh_param(4); 
    c = hh_param(5);
   
    %  stimulus is constant current injection
    I = 0;
    if (t>=stim_param(1) & t<=stim_param(1)+stim_param(2))
       I = stim_param(3);  % amplitude of stimulus
    end
    % Fitzhugh nonlinear equations
    dXdt(1) = (1/Tau)*( X(1) - (X(1)^3)/3 - X(2) + I);
    dXdt(2) = (1/TauR)*(a*X(1) - b*X(2) + c);
    return
    
% end % fhp
