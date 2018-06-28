de = 0; %kT
eT = 0;
eR = de;
ee = 2; %kT
ee1 = exp(-B * ee); 
B = 1;
x = linspace(0,2, 1000);
y = x.*exp(-B * de);

w0t = 1; w1t = 2*x; w2t  = x.^2;
w0r = ee1; w1r = 2*ee1*y; w2r = ee1*y.^2;
Z = w0t + w1t + w2t + w0r + w1r + w2r;
pot= w0t ./ Z; p1t = w1t./ Z; p2t = w2t./Z;
por= w0r ./ Z; p1r = w1r./ Z; p2r = w2r./Z;

figure(1)
plot(x, pot)
hold on
plot(x, p1t)
plot(x, p2t)
plot(x,por)
plot(x,p1r)
plot(x,p2r)
leg = legend('pot', 'p1t', 'p2t', 'por', 'p1r', 'p2r');
hold off
title('Probability of having 0, 1, or 2 bound oxygen molecules in the dimoglobin molecule at STP');
xlabel('x')
ylabel('probability')
ylim([0,1])
% standardizeFigure(gca, leg)


