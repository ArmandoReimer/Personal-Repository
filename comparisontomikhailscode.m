close all force;
d = LoadMS2Sets('newcodecomparison');

figure(1)
plot(d(1).MeanVectorAll, d(2).MeanVectorAll, '.')
hold on;
plot(1:2000, 1:2000);
xlabel('Mikhail MeanVectorAll (A.U.)');
ylabel('Armando MeanVectorAll (A.U.)');
legend('Data', 'y = x');

figure(2)
plot(d(1).ElapsedTime, d(1).MeanOffsetVector*100);
hold on
plot(d(2).ElapsedTime, d(2).MeanOffsetVector*100);
legend('Mikhail', 'Armando');
xlabel('Time since nc14 (min)');
ylabel('MeanOffsetVector Intensity (A.U.)');

figure(3)
plot(d(1).ElapsedTime, d(1).MeanVectorAll);
hold on
plot(d(2).ElapsedTime, d(2).MeanVectorAll/2.2);
legend('Mikhail', 'Armando');
xlabel('Time since nc14 (min)');
ylabel('MeanVectorAll Intensity (A.U.)');


