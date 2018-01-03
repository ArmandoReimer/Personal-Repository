
close all force

BcdMax = 10000; %nM
lambda = .2; %fraction anterior-posterior. bicoid gradient decay length.
ap = 0: .01 :1; %number of points arbitrary
Bcd = BcdMax*exp(-ap/lambda); %nM
r = 1; %mRNA / unit time
KD  = [5, 50, 500]; %nM. 500 from (Ma, 1996)
rate5 = r*( (Bcd/KD(1)) ./ (1+ Bcd/KD(1)) );
rate50 = r*( (Bcd/KD(2)) ./ (1+ Bcd/KD(2)) );
rate500 = r*( (Bcd/KD(3)) ./ (1+ Bcd/KD(3)) ); %dmRNA/dt as a function of activator concentration

figure
p1 = plot(ap, rate5);
hold on
p2 =plot(ap, rate50);
p3 = plot(ap, rate500);
legend('K_D = 5 nM','K_D = 50 nM', 'K_D = 500 nM');
title('predicted 1x rate')
ylabel('rate (normalized mRNA / min)')
xlabel('fraction AP')
xlim([0,1]);
standardizeFigure(gca,[])
hold off
saveas(gcf, 'D:\Data\Armando\livemRNA\Figures\syntheticKdModel.png')

%same thing but plotted against [Bcd]
figure()
s1 = semilogx(Bcd, rate5);
hold on
s2 = semilogx(Bcd, rate50);
s3 = semilogx(Bcd, rate500);
legend('K_D = 5 nM','K_D = 50 nM', 'K_D = 500 nM');
title('predicted 1x rate')
ylabel('rate (normalized mRNA / min)')
xlabel('Bcd (nM)')
xlim([0,BcdMax]);
standardizeFigure(gca,[])
hold off
saveas(gcf, 'D:\Data\Armando\livemRNA\Figures\syntheticKdModeBcdAxis.png')
