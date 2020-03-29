close all force
a = gobjects(1, 5);
a(1) = figure;
a(2) = gca;
% a(3) = legend(ax, [e1, e2], {'apple', 'orange'})
a(3) = errorbar(1, 1, 1, 'r')
hold on
a(4) = errorbar(1, 1, 1, 'k')
a(5) = legend(gca, [a(3), a(4)], 'apple', 'orange', 'AutoUpdate', 'off')
a(6) = errorbar(1, 1, 1, 'b', 'DisplayName', 'protein')
a(5).PlotChildren(end+1) = a(6);

