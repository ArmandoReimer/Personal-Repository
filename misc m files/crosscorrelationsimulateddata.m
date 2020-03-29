genelengthr = 6.1; %kb half ms2 + lacz + half pp7 1.4 + .7 + 3 + 1
genelengthg = 1.7; %kb half pp7 + utr
elongationrate = 4; %kb/min
tdur = 13; %min
samp = .3; %min^-1
tonr = 2; %spots turn on during minute 3
tong = tonr + 4.4/elongationrate; %half ms2 + lacz + halfpp7
telonr = genelengthr / elongationrate;
telong = genelengthg/elongationrate;
Iog = 0;
dIg = 5;
Ior = 0;
dIr = 1;

syms t;
assume(t < tdur);
g = piecewise(0 < t < tong, Iog, tong<t<(telong+tong), Iog + dIg*(t-tong), (telong+tong)<t<tdur, Iog + dIg*telong);
figure(1)
fplot(g)
ylim([0, 3])
xlim([0, 13])
title('traces. telong = 1.5. telonr = .42')
hold on

r = piecewise(0 < t < tonr, Ior, tonr<t<(telonr+tonr), Ior + dIr*(t-tonr), (telonr+tonr)<t<tdur, Ior + dIr*telonr);
fplot(r)
hold off

figure(2)

r = matlabFunction(r)
r = double(r);
g = double(g);
[ccor, lag] = xcorr(r, g);
plot(lag, ccor)

      
