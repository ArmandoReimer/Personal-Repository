% Define some colors
yw = [234 194 100]/256; % yellow
bl = [115 143 193]/256; % blue
rd = [213 108 85]/256; % red
gr = [191 213 151]/256; % green
br = [207 178 147]/256; % brown

ax = gca;
ax.Color = 'none';
pl = ax.Children;
pl.Marker = 'o';
pl.MarkerEdgeColor = 'none';
pl.MarkerFaceColor = rd;
pl.MarkerSize = 8;
pl.LineWidth = .5;
ax.LineWidth = .5;
ax.TickLength = [0.01, 0.01];
ax.TickDir = 'in';
pl.LineStyle = '-';


StandardFigure(pl, ax);

