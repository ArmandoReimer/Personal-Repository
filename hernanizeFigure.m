% Define some colors
yw = [234 194 100]/256; % yellow
bl = [115 143 193]/256; % blue
rd = [213 108 85]/256; % red
gr = [191 213 151]/256; % green
br = [207 178 147]/256; % brown

ax = gca;
ax.Color = 'none';
ax.LineWidth = .5;
ax.TickLength = [0.01, 0.025];
ax.TickDir = 'in';

for i = 1:length(ax.Children)
    
    pl = ax.Children(i);
    pl.Marker = 'o';
    pl.MarkerEdgeColor = 'none';
    pl.MarkerFaceColor = rd;
    pl.MarkerSize = 8;
    pl.LineWidth = .5;
    pl.LineStyle = '-';

end


StandardFigure(ax.Children, ax);

