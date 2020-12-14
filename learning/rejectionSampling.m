f = @(x) x.^3 ./ (exp(x)-1);
x = 0:.1:300;

plot(x, f(x))
hold on
ymax = max(f(x));
yline(ymax)
xmin = 0;
xmax = 10000;
xline(xmax)
n = 1E4;
r1 = xmax*rand([1, n]);
r2 = ymax * rand([1,n]);
reject = r2 > f(r1);
r1(reject) = [];
r2(reject) = [];
plot(r1, r2, '.');
xlim([0, 15])


