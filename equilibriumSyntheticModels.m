
% f = openfig('E:\Armando\Figures\fraction_1A3_error.fig');
f = openfig('E:\Armando\Figures\initial_rate_1A3.fig');

%Plot different parameter ranges for the langmuir isotherm model of
%synthetic binding

hold on

BcdMax = [5000, 10000, 20000]; %nM. 10000 is the number i trust. 
lambda = .2; %fraction anterior-posterior. bicoid gradient decay length.
ap = .25: .01 :7; %number of points arbitrary

Bcd = BcdMax(2)*exp(-ap/lambda); %nM
Bcd5000 = BcdMax(1)*exp(-ap/lambda); %nM
Bcd20000 = BcdMax(3)*exp(-ap/lambda); %nM

r = 1; %mRNA / unit time
KD  = [5, 50, 500]; %nM. 500 from (Ma, 1996
eps = [-100, -10, -1, 1, 10, 100]; %energy of chromatin opening
beta = 1; % -kT

%model 1
p_on_3 = @(conc, KD) ( conc/KD ./ (1+(conc/KD)) ); %conc in nM
%model 2
p_on_2 = @(conc, KD, eps) ( (exp(-beta*eps) + exp(-beta*eps).*(conc/KD))...
    ./ (1+exp(-beta*eps) + exp(-beta*eps).*(conc/KD)) );
%model 3
p_on_dot = p_on_2;
p_on3 = p_on_dot * delta_t;


rate5 = r*occ1(Bcd, KD(1));
rate50 = r*occ1(Bcd, KD(2));
rate500 = r*occ1(Bcd,KD(3)); %dmRNA/dt as a function of activator concentration
rate4 = r*occ1(Bcd5000, KD(3));
rate5 = r*occ1(Bcd20000, KD(3));
rate6 = r*occ1(Bcd5000, KD(1));
rate7 = r*occ1(Bcd20000, KD(3));
rate8 = r*occ1(Bcd5000, KD(3));

figure(f)
% p1 = plot(ap, rate5);
% hold on
% p2 = plot(ap, rate50);
% p3 = plot(ap, rate500);
% p4 = plot(ap, rate4);
% p5 = plot(ap, rate5);
% p6 = plot(ap, rate6);
% p7 = plot(ap, rate7);
% p8 = plot(ap, rate8);
ap2 = [ap, fliplr(ap)];
inBetween = [rate50, fliplr(rate4)];
shading = fill(ap2, inBetween, [115,142,193]/255);
% legend('K_D = 5 nM','K_D = 50 nM', 'K_D = 500 nM', 'rate4', 'rate5');
title('predicted 1x rate')
ylabel('rate (normalized mRNA / min)')
xlabel('fraction AP')
xlim([0.25,.7]);
% standardizeFigure(gca,[])
% p1.Marker = 'none';
% p2.Marker = 'none';
% p3.Marker = 'none';
% p4.Marker = 'none';
% p5.Marker = 'none';
shading.FaceAlpha = .3;
hold off
% saveas(gcf, 'D:\Data\Armando\livemRNA\Figures\syntheticKdModel.png')
% 
% %same thing but plotted against [Bcd]
% figure(2)
% s1 = semilogx(Bcd, rate5);
% hold on
% s2 = semilogx(Bcd, rate50);
% s3 = semilogx(Bcd, rate500);
% legend('K_D = 5 nM','K_D = 50 nM', 'K_D = 500 nM');
% title('predicted 1x rate')
% ylabel('rate (normalized mRNA / min)')
% xlabel('Bcd (nM)')
% xlim([0,BcdMax]);
% standardizeFigure(gca,[])
% s1.Marker = 'none';
% s2.Marker = 'none';
% s3.Marker = 'none';
% 
% hold off
% % saveas(gcf, 'D:\Data\Armando\livemRNA\Figures\syntheticKdModeBcdAxis.png')
