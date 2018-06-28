e = -5; %kT
J = -2.5; %kT
co = 760; %mmHg
B = 1;
c = linspace(10^(-2), 10^2, 1000);
c1 = c/co;

w0 = 1; w1 = 2*c1.*exp(-B*e); w2 = (c1.^2).*exp(-B*(2*e + J));
Z = w0 + w1 + w2;
po = w0 ./ Z; p1 = w1 ./ Z; p2 = w2./Z;

figure(1)
semilogx(c, po)
hold on
semilogx(c, p1)
semilogx(c, p2)
leg = legend('po', 'p1', 'p2');
hold off
title('Probability of having 0, 1, or 2 bound oxygen molecules in the dimoglobin molecule at STP');
xlabel('oxygen partial pressure (mmHg)')
ylabel('probability')
ylim([0,1])
standardizeFigure(gca, leg)


