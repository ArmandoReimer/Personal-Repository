%Let's plot the current for Vapplied = -95mV (column 6)

% figure(1)
% plot(KellerData(:,1), KellerData(:,6),'-k')
% ylabel('Current (pA)')
% xlabel('Time (ms)')
% 
% %Plot a histogram of KellerData 
% 
% figure(2)
% hist(KellerData(:,6), 30) %30 bins. -85 mV
% xlabel('Current (pA)')
% ylabel('Counts')

%Decide on a threshold 

Threshold = -1.5;
totalTimePoints = length(KellerData(:, 6));
open_time_points = sum(KellerData(:,6) < Threshold);
pOpen = open_time_points / totalTimePoints;

V = -135:10:-55;
pOpen = [.013, .035, .01513, .2629, .537, .789, .8207, .842, .9792];
figure(3)
plot(V,pOpen, '.r')
V0 = -94; %our guess for Vo
alpha = -.096; %in units of kT/mV
VRange = linspace(-140,-40);
hold on
plot(VRange, (1+exp(alpha*(VRange-V0))).^(-1), '-r');






