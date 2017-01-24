
%plot(ElapsedTime,MeanVectorAP)
%plot(ElapsedTime(nc13:nc14),MeanVectorAP(nc13:nc14,:))
%plot(ElapsedTime,NParticlesAP)
%plot(ElapsedTime,NParticlesAP)
%xlabel('Elapsed Time (minutes)')

%figure(1)
%plot(ElapsedTime,NParticlesAP)
%l = legend('1', '2','3','4','5','6','7','8','9','10','11','12','13','14','15',...
    %'16','17','18','19','20','21','22','23','24','25','26','27','28','29',...
    %'30','31','32','33','34','35','36','37','38','39','40','41');
%title(l, 'AP Bins')
%xlabel('Time (min)')
%ylabel('N_{particles}')

% numAPBins = size(MeanVectorAP);
% 
% set(groot,'defaultAxesColorOrder', parula(numAPBins(2)))
% 
% figure(2)
% plot(ElapsedTime(1:nc13),MeanVectorAP(1:nc13,:))
% title('nc13 - Mean Fluorescence vs Time vs AP')
% xlabel('Time (min)')
% ylabel('Mean Fluorescence')
% c = colorbar;
% c.Label.String = 'AP Position';
% 
% 
% figure(3)
% plot(ElapsedTime(nc13:nc14),MeanVectorAP(nc13:nc14,:))
% title('nc14 - Mean Fluorescence vs Time vs AP')
% xlabel('Time (min)')
% ylabel('Mean Fluorescence')
% c = colorbar;
% c.Label.String = 'AP Position';

%% Plot Results from FitMeanAPSymmetric

%PLUS5 CONSTRUCT
load('plus5_Combined_MeanFits.mat')
load('plus5_Combined_CompiledParticles.mat')

APBin = APbinID;

%Fitted Rate and time on/off
rateFit5 = NaN(1,41);
timeOn5 = NaN(1,41);
timeOff5 = NaN(1,41);
for i = 1:41
    if ~isempty(FitResults(i,2).RateFit)
        rateFit5(1,i) = FitResults(i,2).RateFit;
    end
    if ~isempty(FitResults(i,2).TimeStart)
        timeOn5(1,i) = FitResults(i,2).TimeStart;
    end
    if ~isempty(FitResults(i,2).TimeEnd)
        timeOff5(1,i) = FitResults(i,2).TimeEnd;
    end
end

%Ratio of partiles on
onRatio5 = OnRatioLineageAP(:,2);

%Integrated mRNA intensity
intensity5 = MeanVectorAP;
intensity5(isnan(intensity5)) = 0;
integratedMRNA5 = trapz(intensity5);

% MINUS1 CONSTRUCT

load('minus1_Combined_MeanFits.mat')
load('minus1_Combined_CompiledParticles.mat')

%Fitted Rate and time on/off
rateFit1 = NaN(1,41);
timeOn1 = NaN(1,41);
timeOff1 = NaN(1,41);

for i = 1:41
    if ~isempty(FitResults(i,2).RateFit)
        rateFit1(1,i) = FitResults(i,2).RateFit;
    end
    if ~isempty(FitResults(i,2).TimeStart)
        timeOn1(1,i) = FitResults(i,2).TimeStart;
    end
    if ~isempty(FitResults(i,2).TimeEnd)
        timeOff1(1,i) = FitResults(i,2).TimeEnd;
    end
end

%Ratio of partiles on
onRatio1 = OnRatioLineageAP(:,2);

%Integrated mRNA intensity
intensity1 = MeanVectorAP;
intensity1(isnan(intensity1)) = 0;
integratedMRNA1 = trapz(intensity1);

% MINUS4 CONSTRUCT

load('minus4_Combined_MeanFits.mat')
load('minus4_Combined_CompiledParticles.mat')

%Fitted Rate and time on/off
rateFit4 = NaN(1,41);
timeOn4 = NaN(1,41);
timeOff4 = NaN(1,41);

for i = 1:41
    if ~isempty(FitResults(i,2).RateFit)
        rateFit4(1,i) = FitResults(i,2).RateFit;
    end
    if ~isempty(FitResults(i,2).TimeStart)
        timeOn4(1,i) = FitResults(i,2).TimeStart;
    end
    if ~isempty(FitResults(i,2).TimeEnd)
        timeOff4(1,i) = FitResults(i,2).TimeEnd;
    end
end

%Ratio of partiles on
onRatio4 = OnRatioLineageAP(:,2);

%Integrated mRNA intensity
intensity4 = MeanVectorAP;
intensity4(isnan(intensity4)) = 0;
integratedMRNA4 = trapz(intensity4);

%NONE CONSTRUCT
load('none_Combined_MeanFits.mat')
load('none_Combined_CompiledParticles.mat')

APBin = APbinID;

%Fitted Rate and time on/off
rateFitNone = NaN(1,41);
timeOnNone = NaN(1,41);
timeOffNone = NaN(1,41);
for i = 1:41
    if ~isempty(FitResults(i,2).RateFit)
        rateFitNone(1,i) = FitResults(i,2).RateFit;
    end
    if ~isempty(FitResults(i,2).TimeStart)
        timeOnNone(1,i) = FitResults(i,2).TimeStart;
    end
    if ~isempty(FitResults(i,2).TimeEnd)
        timeOffNone(1,i) = FitResults(i,2).TimeEnd;
    end
end

%Ratio of partiles on
onRatioNone = OnRatioLineageAP(:,2);

%Integrated mRNA intensity
intensityNone = MeanVectorAP;
intensityNone(isnan(intensityNone)) = 0;
integratedMRNANone = trapz(intensityNone);

lineWidth = 2;
markerSize = 14;

figure(1)
plot(APBin, rateFit5,'.-k','LineWidth',lineWidth,'MarkerSize',markerSize)
hold on;
plot(APBin, rateFit1, '.-r','LineWidth',lineWidth,'MarkerSize',markerSize)
plot(APBin, rateFit4, '.-b','LineWidth',lineWidth,'MarkerSize',markerSize)
plot(APBin, rateFitNone, '.-g','LineWidth',lineWidth,'MarkerSize',markerSize)
axis([0 1 0 inf])
title('Rate')
xlabel('AP')
ylabel('Rate')
l = legend('+5', '-1','-4','None')
set(l,'FontSize', 14)
set(gca,'fontsize',14)

figure(2)
plot(APBin, timeOn5,'.-k','LineWidth',lineWidth,'MarkerSize',markerSize)
hold on;
plot(APBin, timeOn1,'.-r','LineWidth',lineWidth,'MarkerSize',markerSize)
plot(APBin, timeOn4,'.-b','LineWidth',lineWidth,'MarkerSize',markerSize)
plot(APBin, timeOnNone,'.-g','LineWidth',lineWidth,'MarkerSize',markerSize)
axis([0 1 0 inf])
title('t_{on}')
xlabel('AP')
ylabel('TimeStart (min)')
l = legend('+5', '-1','-4','None')
set(l,'FontSize', 14)
set(gca,'fontsize',14)

figure(3)
plot(APBin, timeOff5,'.-k','LineWidth',lineWidth,'MarkerSize',markerSize)
hold on;
plot(APBin, timeOff1,'.-r','LineWidth',lineWidth,'MarkerSize',markerSize)
plot(APBin, timeOff4,'.-b','LineWidth',lineWidth,'MarkerSize',markerSize)
plot(APBin, timeOffNone,'.-g','LineWidth',lineWidth,'MarkerSize',markerSize)
axis([0 1 0 inf])
title('t_{off}')
xlabel('AP')
ylabel('TimeEnd (min)')
l = legend('+5', '-1','-4','None')
set(l,'FontSize', 14)
set(gca,'fontsize',14)

figure(4)
plot(APBin, integratedMRNA5,'.-k','LineWidth',lineWidth,'MarkerSize',markerSize)
hold on;
plot(APBin, integratedMRNA1,'.-r','LineWidth',lineWidth,'MarkerSize',markerSize)
plot(APBin, integratedMRNA4,'.-b','LineWidth',lineWidth,'MarkerSize',markerSize)
% plot(APBin, integratedMRNANone,'.-g','LineWidth',lineWidth,'MarkerSize',markerSize)
axis([0 1 -inf inf])
title('Total mRNA')
xlabel('AP')
ylabel('Total mRNA (Integrated Intensity)')
l = legend('+5', '-1','-4','None')
set(l,'FontSize', 14)
set(gca,'fontsize',14)

figure(5)
plot(APBin, onRatio5,'.-k','LineWidth',lineWidth,'MarkerSize',markerSize)
hold on;
plot(APBin, onRatio1,'.-r','LineWidth',lineWidth,'MarkerSize',markerSize)
plot(APBin, onRatio4,'.-b','LineWidth',lineWidth,'MarkerSize',markerSize)
plot(APBin, onRatioNone,'.-g','LineWidth',lineWidth,'MarkerSize',markerSize)
axis([0 1 -inf inf])
title('Fraction of Active Nuclei')
xlabel('AP')
ylabel('Fraction of Active Nuclei')
l = legend('+5', '-1','-4','None')
set(l,'FontSize', 14)
set(gca,'fontsize',14)
  

%% Plot Integrated mRNA for individual embryos
allDataM1 = LoadMS2Sets('minus1','2016-09-19-1A3-1-evePr_2');
allDataM4 = LoadMS2Sets('minus4','2016-10-25-1A3-4-evePr_2');
allDataP5 = LoadMS2Sets('plus5','2016-09-26-1A3+5-evePr_2');
allDataNone = LoadMS2Sets('none','2016-11-09-0A3-evePr_2');

numEmbryosM1 = size(allDataM1,2);   %5
numEmbryosM4 = size(allDataM4,2);   %5
numEmbryosP5 = size(allDataP5,2);   %8
numEmbryosNone = size(allDataNone,2); %5

APBin = allDataM1(1).APbinID;

integratedMRNA_M1 = zeros(numEmbryosM1, 41);
integratedMRNA_M4 = zeros(numEmbryosM4, 41);
integratedMRNA_P5 = zeros(numEmbryosP5, 41);
integratedMRNA_None = zeros(numEmbryosNone, 41);


%Integrated mRNA intensity
for i = 1:numEmbryosM1
    intensityM1 = allDataM1(i).MeanVectorAP;
    intensityM1(isnan(intensityM1)) = 0;
    integratedMRNA_M1(i,:) = trapz(intensityM1);
end
averageM1 = mean(integratedMRNA_M1);
stdevM1 = std(integratedMRNA_M1) / sqrt(size(integratedMRNA_M1,2));

for i = 1:numEmbryosM4
    intensityM4 = allDataM4(i).MeanVectorAP;
    intensityM4(isnan(intensityM4)) = 0;
    integratedMRNA_M4(i,:) = trapz(intensityM4);
end
averageM4 = mean(integratedMRNA_M4);
stdevM4 = std(integratedMRNA_M4) / sqrt(size(integratedMRNA_M4,2));

for i = 1:numEmbryosP5
    intensityP5 = allDataP5(i).MeanVectorAP;
    intensityP5(isnan(intensityP5)) = 0;
    integratedMRNA_P5(i,:) = trapz(intensityP5);
end
averageP5 = mean(integratedMRNA_P5);
stdevP5 = std(integratedMRNA_P5) / sqrt(size(integratedMRNA_P5,2));

for i = 1:numEmbryosNone
    intensityNone = allDataNone(i).MeanVectorAP;
    intensityNone(isnan(intensityNone)) = 0;
    integratedMRNA_None(i,:) = trapz(intensityNone);
end
averageNone = mean(integratedMRNA_None);
stdevNone = std(integratedMRNA_None) / sqrt(size(integratedMRNA_None,2));


figure(6)
hold on;
for i = 1:numEmbryosM1
    plot(APBin, integratedMRNA_M1(i,:),'.-','LineWidth',1,'MarkerSize',10)
end
axis([0 1 -inf inf])
title('Total mRNA, -1 Construct')
xlabel('AP')
ylabel('Total mRNA (Integrated Intensity)')
legend('Embryo 1', 'Embryo 2','Embryo 3','Embryo 4','Embryo 5');
hold off;

figure(7)
hold on;
for i = 1:numEmbryosM4
    plot(APBin, integratedMRNA_M4(i,:))
end
axis([0 1 -inf inf])
title('Integrated mRNA for Each Individual Embryo, minus4 Constructs')
xlabel('AP')
ylabel('Integrated Intensity (Integrated mRNA)')

figure(8)
hold on;
for i = 1:numEmbryosP5
    plot(APBin, integratedMRNA_P5(i,:))
end
axis([0 1 -inf inf])
title('Integrated mRNA for Each Individual Embryo, plus5 Constructs')
xlabel('AP')
ylabel('Integrated Intensity (Integrated mRNA)')

figure(9)
hold on;
for i = 1:numEmbryosNone
    plot(APBin, integratedMRNA_None(i,:))
end
axis([0 1 -inf inf])
title('Integrated mRNA for Each Individual Embryo, none Constructs')
xlabel('AP')
ylabel('Integrated Intensity (Integrated mRNA)')

figure(10)
hold on;
errorbar(APBin, averageP5, stdevP5, '.-k', 'LineWidth', 1,'MarkerSize', 14)
errorbar(APBin, averageM1, stdevM1, '.-r', 'LineWidth', 1,'MarkerSize', 14)
errorbar(APBin, averageM4, stdevM4, '.-b', 'LineWidth', 1,'MarkerSize', 14)
errorbar(APBin, averageNone, stdevNone, '.-g', 'LineWidth', 1,'MarkerSize', 14)
axis([0 1 -inf inf])
title('Total mRNA by AP Position for Phase Shifted Constructs')
xlabel('AP')
ylabel('Total mRNA (Integrated Intensity)')
h = legend('+5', '-1','-4','None');
set(h,'FontSize',12);

%% Theoretical Plots

A_0 = 120;      %[nM]
lambda = 0.2;   %[AP units]
% K_off = 1;
% K_on = 10^-1;
% K_d = K_off ./ K_on;
K_d = 50;        %[nM], just an estimate but in the right ballpark
rate = 1;
w = 3;
theta = (2*pi/10.5)*[-5:5];
cos105 = cos(theta); 
cos105H = cos105 + pi;

APBins = [0,0.025,0.050,0.075,0.100,0.125,0.150,0.175,0.200,0.225,0.250,...
          0.275,0.300,0.325,0.350,0.375,0.400,0.425,0.450,0.475,0.500,...
          0.525,0.550,0.575,0.600,0.625,0.650,0.675,0.700,0.725,0.750,...
          0.775,0.800,0.825,0.850,0.875,0.900,0.925,0.950,0.975,1];
exponential = exp(-APBins./lambda);
A = A_0*exponential;

exprRate = (A./K_d).*rate./(1 + (A./K_d));
exprRateTwoSites =( (A./K_d) + w*(A./K_d).^2).*rate./(1 + (A./K_d) + w*(A./K_d).^2);
exprRateThreeSites = ( 3*(A./K_d) + 2*w*(A./K_d).^2 + w^2*(A./K_d).^3).*rate./(1 + 3*(A./K_d) + 2*w*(A./K_d).^2 + w^2*(A./K_d).^3);
fractionOn = (A./K_d)./(1 + (A./K_d));

rateHelicalM4 = (cos105(2) + pi)*exprRate;
rateHelicalM1 = (cos105(5) + pi)*exprRate;
rateHelicalP5 = (cos105(11) + pi)*exprRate;
rateHelical = cos105H*exprRate(21);

lineWidth = 3;

figure(11)
plot(APBins, exprRate,'-k', 'LineWidth',lineWidth)
hold on
plot(APBins, exprRateTwoSites,'-r', 'LineWidth',lineWidth)
plot(APBins, exprRateThreeSites,'-b', 'LineWidth',lineWidth)
hold off
title({'The Effect of Multiple Binding Sites', 'On Transcription Initiation Rate'});
xlabel('Fraction of Embryo Length')
ylabel('Initiation Rate')
legend('One Bcd Site', 'Two Bcd Sites', 'Three Bcd Sites')
set(gca,'fontsize',60)
% 
% figure(12)
% plot(APBins, fractionOn,'-r', 'LineWidth',lineWidth)
% title('Prediction for Fraction of ''On'' Nuclei')
% xlabel('AP')
% ylabel('Fraction of ''On'' Nuclei')
% set(gca,'fontsize',14)



figure(13)
% plot(APBins, rateHelicalM4, '-b', 'LineWidth',lineWidth)
% hold on;
% plot(APBins, rateHelicalM1, '-r', 'LineWidth',lineWidth)
% plot(APBins, rateHelicalP5, '-k', 'LineWidth',lineWidth)
% hold off;
for i = 1:11
    r = (cos105(i) + pi)*exprRate;
    plot(APBins,r,'LineWidth', lineWidth);
    hold on
end
title({'Dependence of Transcription Initiation Rate on', 'Relative Position of Bcd Binding Site'},'FontName', 'Calibri', 'FontSize', 60, 'FontWeight', 'bold')
xlabel('Fraction of Embryo Length','FontName', 'Calibri', 'FontSize', 60, 'FontWeight', 'bold')
ylabel('Initiation Rate', 'FontName', 'Calibri', 'FontSize', 60, 'FontWeight', 'bold')
l = legend('-5', '-4', '-3', '-2', '-1', '0',...
    '+1', '+2', '+3', '+4', '+5', 'Orientation', 'horizontal');
set(l,'FontSize',60);

figure(14)
plot([-5:5], rateHelical,'LineWidth',lineWidth)
title({'Transcription Initiation Rate','at 50% AP by Construct'}) 
axis([-6 6 0.3 0.7])
xlabel('Relative Position of Bcd Binding Site')
ylabel('Initiation Rate')
set(gca,'fontsize',60)

% txt1 = '- 4';
% text(-3.5,0.4,txt1,'FontSize',60)
% txt2 = '- 1';
% text(-1.85,0.65,txt2,'FontSize',60)
% txt3 = '+ 5';
% text(5,0.335,txt3,'FontSize',60)

% B=0;