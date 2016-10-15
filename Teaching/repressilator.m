r = 30; %production of proteins per minute
gamma = 1/30; %degradation in proteins/minute
Kd = 200; %Dissociation constant (same for both repressors) in number of proteins

R = linspace(0,1000);
%start by plotting the nullclines
figure(1)
plot(R, r/gamma*1./(1+(R/Kd).^2), '-r');
hold on
plot(r/gamma*1./(1+(R/Kd).^2), R, '-g');
xlabel('R1')
ylabel('R2')
legend('dR2/dt = 0', 'dR1/dt = 0');

[R1M, R2M] = meshgrid(R(1:2:end), R(1:2:end));
dR1M= -gamma*R1M+r./(1+(R2M/Kd).^2);
dR2M= -gamma*R2M+r./(1+(R1M/Kd).^2);

quiver(R1M, R2M, dR1M, dR2M, 1.5,'LineWidth', 1)

%Now simulate the dynamics of R1 and R2 with a given initial condition

R1 = [200];
R2 = [500];
ttot = 180;
dt = 1;
T = [1];

for t = 2:dt:ttot
        
        T(t) = t;
        R1(t)= R1(t-1) - gamma*R1(t-1)*dt + r*(1/(1+(R2(t-1)/Kd).^2))*dt;
        R2(t)= R2(t-1) - gamma*R2(t-1)*dt + r*(1/(1+(R1(t-1)/Kd).^2))*dt;
        hold on
        plot(R1, R2, 'ok', 'MarkerSize', 20);
        drawnow
end




