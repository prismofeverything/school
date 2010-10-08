%Fourth Order Runge-Kutta for N-Dimensional Systems
clear all; hold off; clc;
SD = clock;  % Three lines to set new random # seed
SD = round((SD(4) + SD(5) + SD(6))*10^3);
rand('seed', SD);
Total_Neurons = 2;  %Solve for this number of interacting Neurons
DT = 0.02;  %Time increment as fraction of time constant
Final_Time = 500;   %Final time value for calculation
Last = Final_Time/DT + 1;  %Last time step
Time = DT*[0:Last-1];  %Time vector
Tau = 0.8;  %Neural time constants in msec
TauR = 1.9;
WTS = [1 2 2 1];  %Runge-Kutta Coefficient weights
for NU = 1:Total_Neurons;  %Initialize
	X(NU, :) = zeros(1, Last);  %Vector to store response of Neuron #1
	K(NU, :) = zeros(1, 4);  %Runge-Kutta terms	
	Weights(NU, :) = WTS;  %Make into matrix for efficiency in main loop
end;
X(1, 1) = -0.70;  %Initial conditions here if different from zero
X(2, 1) = 0.088;  %Initial conditions here if different from zero
Wt2 = [0 .5 .5 1];  %Second set of RK weights
rkIndex = [1 1 2 3];
Stim = input('Stimulating current amplitude (0-2): ');
SDnoise = input('Standard Deviation of noise = ');
Freq = input('Stimulus frequency in Hz (> 50) = ');
whitebg('w');
T1 = clock;
for T = 2:Last;
  for rk = 1:4  %Fourth Order Runge-Kutta
	XH = X(:, T-1) + K(:, rkIndex(rk))*Wt2(rk);
 	Tme =Time(T-1) + Wt2(rk)*DT;  %Time upgrade
		
	K(1, rk) = DT/Tau*(-(17.81 + 47.71*XH(1) + 32.63*XH(1)^2)*(XH(1) - 0.55) - 26*XH(2)*(XH(1) + 0.92) + Stim*sin(2*pi*Freq*Tme/1000) + randn*SDnoise);  
  	K(2, rk) = DT/TauR*(-XH(2) + 1.35*XH(1) + 1.03);

 end;
	X(:, T) = X(:, T-1) + sum((Weights.*K)')'/6;
end;
Calculation_Time = etime(clock, T1)
Ptime = 0:0.1:200;
SineWave = 10*sin(2*pi*Ptime*Freq/1000)-100;

figure('Name',sprintf('Input and response: Stim %5.3f, S.D. Noise %5.3f, Freq %d', Stim, SDnoise, Freq)); 
ZA = plot(Time, 100*X(1, :), 'r-', Ptime, SineWave, 'b-');
axis([0, 100, -120, 50]); xlabel('Time (ms)'); ylabel('V (red) & Stimulus (blue)');
%axis([0, Final_Time, -120, 50]); xlabel('Time (ms)'); ylabel('V (red) & Stimulus (blue)');
set(ZA, 'LineWidth', 2);
VV = -0.9:0.01:1.5;
DVdt = -0.5*((1.37 + 3.67*VV + 2.51*VV.^2).*(VV - 0.55) - Stim/13)./(VV + 0.92);
DRdt = 1.35*VV + 1.03;

% figure; 
% ZB = plot(VV, DVdt, 'k-', VV, DRdt, 'b-', X(1, :), X(2, :), 'r-'); axis([-1, 0.6, 0, 1]);
% set(ZB, 'LineWidth', 2); axis square;

Spikes = (X(1, 1:Last-1) < 0).*(X(1, 2:Last) >= 0);
Num_Spikes = sum(Spikes)
clear X;
Previous = 1;
Next = 1;
When = Time(2:Last).*(Spikes > 0);  %Times at which spikes occur
Interval = zeros(1, Num_Spikes - 1);
clear Spikes;
for K = 2:length(When);
	if When(K) > 0; 
		Interval(Next) = When(K) - When(Previous);
		Previous = K; 
		Next = Next + 1;
		end;
end;
clear When;
figure('Name',sprintf('Interspike interval: Stim %5.3f, S.D. Noise %5.3f, Freq %d', Stim, SDnoise, Freq)); 
hist(Interval, 100);
%figure(3); hist(Interval, 10);
