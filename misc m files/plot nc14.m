
data = LoadMS2Sets('P2POreR_55uW_bidirectional');
clear figure
% i=11;
% j=13;
% k = 14;
for i = 1:length(data)
data(i).ElapsedTime = data(i).ElapsedTime - data(i).ElapsedTime(data(i).nc14);
% data(j).ElapsedTime = data(j).ElapsedTime - data(j).ElapsedTime(data(j).nc14);
% data(k).ElapsedTime = data(k).ElapsedTime - data(k).ElapsedTime(data(k).nc14);

figure(1)
scatter(data(i).ElapsedTime(data(i).nc14:end), data(i).MeanVectorAll(data(i).nc14:end),'DisplayName','Unidirectional')
% scatter(data(i).ElapsedTime(data(i).nc14:end), ~isnan(data(i).MeanOffsetVector(data(i).nc14:end)))
% scatter(data(j).ElapsedTime(data(j).nc14:end), data(j).MeanVectorAll(data(j).nc14:end),'DisplayName','Unidirectional')
% scatter(data(k).ElapsedTime(data(k).nc14:end), data(k).MeanVectorAll(data(k).nc14:end),'DisplayName','Unidirectional')
% scatter(data(j).ElapsedTime(data(j).nc14:end), ~isnan(data(j).MeanOffsetVector(data(j).nc14:end)))
ylabel({'Fluorescence (A.U.)'});
xlabel({'Time since nc14 (mins)'});
title({'Average particle fluorescence in anterior of P2Ps(xOreR) at 55uW 488 nm'});
hold on
end

% legend1 = legend('Unidirectional', 'Bidirectional');
% legend1 = legend('Uni 1', 'Uni 2', 'Uni 3');
% set(legend1,...
%     'Position',[0.628506328273908 0.777331351206476 0.229827005059425 0.0813988075236836],...
%     'FontSize',9);