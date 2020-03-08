%%generate noisy logistic time series
lengthTS = 6000; 
trueChangePoint = [1/3, 2/3].*lengthTS;  % positions of change-points
logisticTS = GenerateLogisticWithChange( lengthTS, trueChangePoint, [3.95, 4, 3.95], 0.1);

%%detect change points
d = 3;
tau = 1; %tau > 1 is currently not implemented
falseAlarmRate = 0.05;  %risk to detect change-point in a stationary signal               
minCPdist = 500;     %minimal distance between change-points (length of stationary interval)
estimatedChangePoint = FindAllOrdinalCP(logisticTS, d, falseAlarmRate, minCPdist)

%%draw change point
xValues = 1:lengthTS;
  
figure;
set( axes,'fontsize', 12, 'FontName', 'Times');
hold on
for i = 1:length(estimatedChangePoint)
  line([estimatedChangePoint(i) estimatedChangePoint(i)],[-1, 2], 'linewidth', 2, 'Color', 'r'); 
end 
for i = 1:length(trueChangePoint)
  line([trueChangePoint(i) trueChangePoint(i)],[-1, 2], 'linewidth', 1, 'Color', 'k'); 
end 
plot(xValues, logisticTS(xValues), '-b', 'linewidth', 1);
hold off
xlabel( ' t  ', 'fontsize', 12, 'FontAngle', 'italic', 'FontName', 'Times');
ylabel( 'NL(\itt\rm; (3.95, 4, 3.95), (L/3, 2L/3)', 'fontsize', 12, 'FontName', 'Times');
