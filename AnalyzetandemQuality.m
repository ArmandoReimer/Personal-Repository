% Plot the SNR and S/background histograms
% SNR = (mean of particle signal / stdev of background) * some coefficient
% Good SNR is given by Roses's criterion: SNR > 5

figure()

Prefix = '2015-11-10-tdMCP-GFP_2_intensity';
[F2Otd2,F2Etd2,~]=DataSetQuality(Prefix,13);
[td2ox,td2oOut]=hist(F2Otd2,15);
plot(td2oOut,td2ox/sum(td2ox),'.-r')
hold on
Prefix = '2015-11-08-tdMCP-GFP_6_intensity';
[F2Otd6,F2Etd6,~]=DataSetQuality(Prefix,13);
[td6ox,td6oOut]=hist(F2Otd6,15);
plot(td6oOut,td6ox/sum(td6ox),'.-b')
hold on
Prefix = '2015-10-15-tdMCP-GFP_9_intensity_1';
[F2Otd9,F2Etd9,~]=DataSetQuality(Prefix,13);
[td9ox,td9oOut]=hist(F2Otd9,15);
plot(td9oOut,td9ox/sum(td9ox),'.-g')
hold on
Prefix = '2015-11-06-tdMCP-GFP_10_intensity';
[F2Otd10,F2Etd10,~]=DataSetQuality(Prefix,13);
[td10ox,td10oOut]=hist(F2Otd10,15);
plot(td10oOut,td10ox/sum(td10ox),'.-k')

xlabel('Signal to background ratio')
ylabel('Frequency')
title('Tandem comparisons')
legend('td2', 'td6', 'td9', 'td10')

%Plot the signal/error histograms
figure()

[td2ex,td2eOut]=hist(F2Etd2,15);
plot(td2eOut,td2ex/sum(td2ex),'.-r')
hold on
[td6ex,td6eOut]=hist(F2Etd6,15);
plot(td6eOut,td6ox/sum(td6ex),'.-g')
hold on
[td9ex,td9eOut]=hist(F2Etd9,15);
plot(td9eOut,td9ex/sum(td9ex),'.-b')
hold on
[td10ex,td10eOut]=hist(F2Etd10,15);
plot(td10eOut,td10ex/sum(td10ex),'.-k')

xlabel('SNR')
ylabel('Frequency')
title('Tandem comparisons')
legend('td2', 'td6', 'td9', 'td10')

%Summarize the data in two scatter plots

figure()

dosages = [59, 72, 131, 135]; %2, 6, 9, 10
meanSO = [mean(F2Otd2), meaen(F2Otd6),mean(F2Otd9),mean(F2Otd10)];
plot(dosages,meanSO);
xlabel('Dosage')
ylabel('Mean S/BG')
title('Tandem comparisons')


figure()

meanSNR = [mean(F2Etd2),mean(F2Etd6),mean(F2Etd9),mean(F2Etd10)];
plot(dosages,meanSNR);
xlabel('Dosage')
ylabel('Mean SNR')
title('Tandem comparisons')


