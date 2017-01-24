function integrateFluorescenceOverAP(dataset)
    
    data = LoadMS2Sets(dataset);
    cum = zeros(0,41);
    data(3) = [];
    for j = 1:length(data)
        fluo = data(j).MeanVectorAP;
        fluo(isnan(fluo)) = 0;
        for i = 1:size(fluo,2)
            cum(j,i) = trapz(data(j).ElapsedTime,fluo(:,i));
        end
    end

    cummean = zeros(1,41);
    cumstd = zeros(1,41);
    cumsum = zeros(1,41);
    for i = 1:length(cum)
        cummean(1, i) = nanmean(cum(:,i));
        cumstd(1, i) = nanstd(cum(:,i));
        if ~cummean(i)
            cummean(i) = NaN;
        end
         if ~cumstd(i)
            cumstd(i) = NaN;
         end
         cumstde(i) = cumstd(i) /  sqrt(sum(cum(:,i) ~= 0));
    end

    figure(1)
    ap = data(1).APbinID;
    plot(ap, cummean, 'LineWidth', 5)
    hold on
    for i = 1:length(data)
        plot(ap, cum(i, :), 'LineWidth', 1)
    end
% %    legend('mean', 'data set 1', 'data set 2',...
%         'data set 3', 'data set 4', 'data set 5')
    xlim([.1, .8])
    title('1A3 Integrated Intensity over AP',...
        'FontName', 'Calibri', 'FontWeight', 'bold','FontSize',40)
    xlabel('% EL','FontName',...
        'Calibri', 'FontWeight', 'bold','FontSize',40)
    ylabel('Intensity (A.U.)'...
        ,'FontName', 'Calibri', 'FontWeight', 'bold','FontSize',40)
    %hold on
    %these next two lines are supposed to plot a logistic fit. Will update
    %this later if needed.
    %     y = (-1.9E4 ./ (1+exp(-(.3*10^2.*(data(1).APbinID - 0.32))))) + 2*10^4
    %plot(data(1).APbinID,y)
%     hold off
    
    
    %plot the same thing with standard errors 
    figure(2)
    errorbar(ap, cummean, cumstde)
    hold on
    for i = 1:length(data)
        plot(ap, cum(i, :))
    end
    xlim([.2, .8])
    ylim([0, 5000])
    title('1A3 Integrated Intensity over AP')
    xlabel('% EL')
    ylabel('Intensity (A.U.)')

%     figure(3)
%     l = 120./cummean.^(-1);
%     ap_mid = ap(13:23);
%     bcd = 120*exp(-ap_mid./.2); %120 nM. .2 is fraction of EL (~100nm)
%     l_mid = l(13:23);
%     plot(bcd, l_mid);
% %     xlim([.3, .6])
%     title('1 / Intensity versus AP')
%     xlabel('% EL')
%     ylabel('1/Intensity (A.U.)')
%     hold on
%     fit = polyfit(bcd, l_mid, 1);
%     y = polyval(fit, ap_mid);
%     plot(ap_mid, y);
%     legend('Data', ['Fit: y =',num2str(fit(1)),'x + ',num2str(fit(2))]);

%     for j = 1:length(data)
%         fluo = data(j).OnRatioAP;
%         fluo(isnan(fluo)) = 0;
%         for i = 1:size(fluo,2)
%                     cum(j,i) = trapz(data(j).ElapsedTime,fluo(:,i)) / (data(j).ElapsedTime(end) - data(j).ElapsedTime(1)); 
% 
%                 end
%     end
% 
%     cummean = zeros(1,41);
%     cumsd = zeros(1,41);
%     for i = 1:length(cum)
%         cummean(1, i) = nanmean(cum(:,i));
%         cumsd(1, i) = nanstd(cum(:,i));
%         if cummean(i) == 0
%             cummean(i) = NaN;
%         end
%          if cumsd(i) == 0
%             cumsd(i) = NaN;
%         end
%     end
%     figure(2)
%     %y = (-1.9E4 ./ (1+exp(-(.3*10^2.*(data(1).APbinID - 0.32))))) + 2*10^4
%     plot(data(1).APbinID, cummean)
%     % xlim([0, .8])
%     % ylim([0, 4500])
%     title('1A3 Integrated Intensity over AP')
%     xlabel('% EL')
%     ylabel('Intensity (A.U.)')
%     % errorbar(data(1).APbinID, cummean, cumsd)
%     %hold on
%     %plot(data(1).APbinID,y)
% end
end
