%Simulate bacterial growth

%Model parameters:

k = 1/20;              %doubling rate in 1/min. 

%Simulation parameter:

dt = .1; %min
t_sim = 60*4;
t_steps = t_sim / dt;

%Initial condition. Define a vector where we will store the number at each
%time point. 

N = [];
N(1) = 1;


for i = 2:t_steps
    N(i) = N(i-1) + N(i-1)*k*dt;
end

N(end)

times = 0:dt:t_sim-dt;

plot(times, N)
xlabel('time (min)');
ylabel('number of bacteria');
title('Exponential growth of bacteria')

figure
semilogy(times,N)
xlabel('time (min)');
ylabel('number of bacteria');
title('Exponential growth of bacteria')





