function copyPlot(ax1, ax2)

    plot1 = ax1.Children;
    y1 = plot1.YData;
    x1 = plot1.XData;
    e1 = plot1.UData;

    hold(ax2, 'on')
    errorbar(ax2, x1, y1, e1);
    standardizeFigure(ax2, [])

end
