function standardizeFigure

set(gca,'LineWidth',5,'TickLength',[0.005 0.005],...
    'FontSize', 40, 'FontName', 'Calibri', 'FontWeight', 'bold');
try
    lgd = legend;
    lgd.FontSize = 15;
catch
    %no legend found
end

end

