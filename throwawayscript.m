% dataTypes = {'1Dg_2xDl', '1DgW_2x_Leica', '1DgW_FFF', '1Dg-5_FFF', '1DgVW_FFF'};
dataTypes = {'1Dg-5_FFF', '1Dg_2xDl', '1DgW_and_1DgW2xDl', '1DgVW_FFF'};
activities = {'fraction', 'max'};
profile off;
profile on;

clrmp = single(hsv(length(dataTypes)));
% clrmp = clrmp(randperm(length(clrmp)), :);

for j = 1:length(activities)
    for i = 1:length(dataTypes)
        if j == 1
%             compileAllProjects(dataTypes{i})
            binDorsal(dataTypes{i}, true)
        end
        plotFracByDlFluo2(dataTypes{i}, activities{j});
        if i == 1
            ax1 =gca;
            for k = 1:length(ax1.Children)
%                 set(ax1.Children, 'Color', clrmp(1), 'MarkerFaceColor', clrmp(1));
                if isprop(ax1.Children(k), 'Color')
                    set(ax1.Children(k), 'Color', clrmp(1, :));
                end
                if isprop(ax1.Children(k), 'MarkerFaceColor')
                    set(ax1.Children(k), 'MarkerFaceColor', clrmp(1, :));
                end
            end
        else
            ax = gca;
            copyPlot(ax, ax1, 'colorMap', clrmp(i, :));
        end
    end
end
profile off;
