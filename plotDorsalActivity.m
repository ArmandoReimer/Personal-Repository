function [fit, model] = plotDorsalActivity(x, y,activity, nc, DataType, ymean, se)

    xx = repmat(x, size(y,2), 1)';

    opts = {};
    if strcmpi(activity, 'fraction competent')
        opts = [opts, 'fraction'];
    end
    [fit, model] = fitDorsalActivity(xx, y, DataType, opts{:});
    idx = ~any(isnan(ymean),2);
    x4 = xx(idx);
    xxx = min(x(:)):.01:max(x4(end)*1.1,fit(2)*2.5);
    
    figure('Units', 'points', 'Position', [0, 0, 200, 200]);
    set(gca,'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1]);
    axis square
    clr = 'r';
    plot(xxx, model(fit,xxx), '-', 'DisplayName',['fit: ',num2str(round(fit))], 'LineWidth', .5, 'Color', clr);
    hold on
    errorbar(xx(idx), ymean(idx), se(idx), 'o', 'DisplayName', DataType, 'MarkerSize', 3, 'MarkerFaceColor', clr, 'CapSize', 0);
%     set(gca, 'Units', 'points', 'Position', [0, 0, 100, 100]);
    xlabel('dorsal concentration (au)');
    ylabel(activity);
    title([DataType, ' nc',num2str(nc+11)]);
    legend(DataType, ['fit: ',num2str(round(fit))], 'Interpreter', 'none')
    leg = get(gca, 'Legend'); w=.02;h=.01;set(leg, 'Units', 'normalized', 'Position', [1-w, 1-h,w, h], 'Box','off');

end