phases = LoadMS2Sets('phase-shifts');
figure;
for i=1:length(phases)
    p = phases(i);
    nc13 = p.nc13;
    nc14 = p.nc14;
    m = p.MeanVectorAnterior(nc13:nc14);
    m(isnan(m)) = 0;
    f = cumtrapz(p.ElapsedTime(nc13:nc14), m);
    f = f./(nc14-nc13);
    h = plot(p.ElapsedTime(nc13:nc14), f, 'Linewidth',3,'DisplayName',p.SetName);
    hold on
end
legend show;
% positions = nan(1, 7);
% g = nan(1, 7);
% figure;
% for i=1:length(phases)
%     p = phases(i);
%     nc13 = p.nc13;
%     nc14 = p.nc14;
%     m = p.MeanVectorAnterior(nc13:nc14);
%     m(isnan(m)) = 0;
%     f = cumtrapz(p.ElapsedTime(nc13:nc14), m);
%     positions(i) = p.Position;
%     if i ~= 5 %this data set was not taken in the anterior
%         g(i) = max(f);
%     end
% end
% g = g ./ max(g);
% scatter(positions, g, '.r', 'SizeData', 18^2);
% title('Effect of helical orientation on mRNA output')
% xlabel('Position relative to original 1A3');
% ylabel('Normalized accumulated intensity');
% xlim([-5 5])
% ylim([0 1.2])
% ax = gca;
% ax.XTick = -5:5;


%commented out because ugly
% figure 
% for i=1:length(phases)
%     p = phases(i);
%     nc13 = p.nc13;
%     nc14 = p.nc14;
%     plot(p.ElapsedTime(nc13:nc14)-nc13, p.MeanVectorAll(nc13:nc14));
%     hold on
% end