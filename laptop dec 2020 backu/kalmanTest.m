function kalmanTest()
%%

%transition matrix
A = 1;

a = blkdiag(A1, A2, A3)
%measurement vector
H = 1;

%noise covariance matrices
Q = 2^2; %process
R = 2^2; %measurement

%initial state
x0 = nan;
P0 = nan;   

s = initializeSystem(A, Q, H, R, x0, P0);

% Generate random positions and watch the filter operate.
tru=[]; % true position
for t=1:20
   tru(end+1) = randn*2+12;
   s(end).z = tru(end) + randn*2; % create a measurement
   s(end+1)=kalmanf(s(end)); % perform a Kalman filter iteration
end
%%


figure
hold on
grid on
% plot measurement data:
hz=plot([s(1:end-1).z],'r.');
% plot a-posteriori state estimates:
hk=plot([s(2:end).x],'b-');
ht=plot(tru,'g-');
legend([hz hk ht],'observations','Kalman output','true voltage')
title('Automobile Voltimeter Example')
hold off

end

function s = initializeSystem(A, Q, H, R, x0, P0)

s.A = A;
s.Q = Q;
s.H = H;
s.R = R;
s.x = x0;
s.P = P0;

s.B = 0;
s.u = 0;

% 
% % Define the system as a constant of 12 volts:
% % s.A = 1;
% 
% % Define a process noise (stdev) of 2 volts as the car operates:
% % s.Q = 2^2; % variance, hence stdev^2
% 
% % Define the voltimeter to measure the voltage itself:
% s.H = 1;
% 
% % Define a measurement error (stdev) of 2 volts:
% s.R = 2^2; % variance, hence stdev^2
% 
% % Do not define any system input (control) functions:
% s.B = 0;
% s.u = 0;
% 
% 
% % Do not specify an initial state:
% s.x = nan;
% s.P = nan;


end
