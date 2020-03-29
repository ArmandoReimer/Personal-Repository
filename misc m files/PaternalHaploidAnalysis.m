function PaternalHaploidAnalysis
    close all force
    data = LoadMS2Sets('PatHapAnaCurated') %only includes data sets 2 3 7 8 and 7/04/15
    %data = LoadMS2Sets('PatHapAna');
%nc13
    cum = zeros(0,41);
    for j = 1:length(data)
        fluo = data(j).MeanVectorAP;
        nc13 = data(j).nc13;
        nc14 = data(j).nc14;
        fluo(isnan(fluo)) = 0;
        for i = 1:size(fluo,2)
            cum(j,i) = trapz(data(j).ElapsedTime(nc13:nc14),fluo(nc13:nc14,i));
        end
    end

    cummean = zeros(1,41);
    cumstd = zeros(1,41);
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
    plot(ap, cummean, 'k', 'LineWidth', 5)
    legendCell = {'Mean'};
    hold on
    
    for i = 1:length(data)
        plot(ap, cum(i, :), 'LineWidth', 5)
        legendCell{i+1} = data(i).SetName;
    end
    legend(legendCell)
    xlim([0,1])
    title('Paternal haploid P2P nc13 AP Profile (all data sets)')
    xlabel('Fraction embryo length')
    ylabel('Intensity (A.U.)')
    standardizeFigure
   
%     %plot the same thing with standard errors 
%     figure(2)
%     errorbar(ap, cummean, cumstde)
%     hold on
%     for i = 1:length(data)
%         plot(ap, cum(i, :))
%     end
%     xlim([0, 1])
%     title('Paternal Haploid P2P AP Profile')
%     xlabel('Fraction embryo length')
%     ylabel('Intensity (A.U.)')
%     legend(legendCell)
    
%nc14
cum = zeros(0,41);
    for j = 1:length(data)
        fluo = data(j).MeanVectorAP;
        nc14 = data(j).nc14;
        fluo(isnan(fluo)) = 0;
        for i = 1:size(fluo,2)
            cum(j,i) = trapz(data(j).ElapsedTime(nc14:end),fluo(nc14:end,i));
        end
    end

    cummean = zeros(1,41);
    cumstd = zeros(1,41);
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

    figure(3)
    ap = data(1).APbinID;
    plot(ap, cummean, 'k', 'LineWidth', 5)
    legendCell = {'Mean'};
    hold on
    
    for i = 1:length(data)
        plot(ap, cum(i, :), 'LineWidth', 5)
        legendCell{i+1} = data(i).SetName;
    end
    legend(legendCell)
    xlim([0,1])
    title('Paternal haploid P2P nc14 AP Profile (all data sets)')
    xlabel('Fraction embryo length')
    ylabel('Intensity (A.U.)')
    standardizeFigure

%Normalized profiles (nc13 control, nc14 paternal haploid)

%Ana normalized data
    load('D:\Data\Armando\livemRNA\Data\Dropbox\DynamicsResults\ComparisonData.mat')
    load('D:\Data\Armando\livemRNA\Data\Dropbox\DynamicsResults\DataForPlots.mat');
    % Normalise the intentsity
    Dimension = size(MeanTotalProd);
    for i = 1:Dimension(1)
        for j = 1:Dimension(2)
            NormMaxMeanTotalProdHernan(i,j) = MeanTotalProd(i,j)./nanmax(MeanTotalProd(1:Dimension(1),j));
        end
    end
    hernancontrol = NormMaxMeanTotalProdHernan(1:Dimension(1),13);
    cum = zeros(0,41);
    for j = 1:length(data)
        fluo = data(j).MeanVectorAP;
        nc13 = data(j).nc13;
        nc14 = data(j).nc14;
        fluo(isnan(fluo)) = 0;
        for i = 1:size(fluo,2)
            cum(j,i) = trapz(data(j).ElapsedTime(nc13:nc14),fluo(nc13:nc14,i));
        end
    end

    cummean = zeros(1,41);
    cumstd = zeros(1,41);
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
    
    cummean = cummean ./ nanmax(cummean);
    
    figure(4)
    ap = data(1).APbinID;
    plot(ap, cummean, 'k', 'LineWidth', 5);
    legendCell = {'Paternal Haploid Mean'};
    hold on
    plot(ap, hernancontrol, 'b', 'LineWidth', 5)
    legendCell{2} = 'Hernan Control Mean';
    legend(legendCell)
    xlim([0,1]);
    ylim([0,1]);
    title('Normalized AP Profile (all data sets)');
    xlabel('Fraction embryo length');
    ylabel('Intensity (A.U.)');
    standardizeFigure;

%integrated using Ana's method
    Dimension = size(MeanTotalProd);
    for i = 1:Dimension(1)
        for j = 1:Dimension(2)
            NormMaxMeanTotalProdHernan(i,j) = MeanTotalProd(i,j)./nanmax(MeanTotalProd(1:Dimension(1),j));
        end
    end
    hernancontrol = NormMaxMeanTotalProdHernan(1:Dimension(1),13);
    
for  i = 1:length(data)
    % looping over the values of AP position
    maxap = length(ap);
    for j = 1:maxap
        nc13= data(i).nc13;  
        nc14 = data(i).nc14;
        if nc13== 0
            TotalIntensityAP(i,j) = NaN;
        else
            for k = nc13:nc14
                TemporaryIntensityAP(k) = data(i).MeanVectorAP(k,j);
            end
            if trapz(nc13:nc14,TemporaryIntensityAP(nc13:nc14)) == 0
                TotalIntensityAP(i,j) = NaN;
            else
                %turn NaN values into 0 since trapz cannot cope with NaN
                TemporaryIntensityAP(isnan(TemporaryIntensityAP)) = 0;
                TotalIntensityAP(i,j) = trapz(nc13:nc14,TemporaryIntensityAP(nc13:nc14));
            end
        end
               
    end  
end
TotalIntensityAP(TotalIntensityAP == 0) = NaN;
MeanIntensityAP = nanmean(TotalIntensityAP,1);
k = 0;
for k = 1:length(MeanIntensityAP)
    if MeanIntensityAP(k) == 0
        MeanIntensityAP(k) = NaN;
    end
end
NormMaxMeanIntensityAP = MeanIntensityAP./nanmax(MeanIntensityAP);
    figure(5)
    ap = data(1).APbinID;
    plot(ap, NormMaxMeanIntensityAP, 'k', 'LineWidth', 5);
    legendCell = {'Paternal Haploid Mean'};
    hold on
    plot(ap, hernancontrol, 'b', 'LineWidth', 5)
    legendCell{2} = 'Hernan Control Mean';
    legend(legendCell)
    xlim([0,1]);
    ylim([0,1]);
    title('Normalized AP Profile using Ana''s code');
    xlabel('Fraction embryo length');
    ylabel('Intensity (A.U.)');
    standardizeFigure;


%control confocal P2P data, nc13
data = LoadMS2Sets('AnaP2PControl');
cum = zeros(0,41);
    for j = 1:length(data)
        fluo = data(j).MeanVectorAP;
        nc14 = data(j).nc14;
        fluo(isnan(fluo)) = 0;
        for i = 1:size(fluo,2)
            cum(j,i) = trapz(data(j).ElapsedTime(nc13:nc14),fluo(nc13:nc14,i));
        end
    end

    cummean = zeros(1,41);
    cumstd = zeros(1,41);
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

    figure(6)
    ap = data(1).APbinID;
    plot(ap, cummean, 'k', 'LineWidth', 5)
    legendCell = {'Mean'};
    hold on
    
    for i = 1:length(data)
        plot(ap, cum(i, :), 'LineWidth', 5)
%         legendCell{i+1} = data(i).SetName;
    end

%     legend(legendCell)
    xlim([0,1])
    title('P2P control nc13 AP Profile (all data sets)')
    xlabel('Fraction embryo length')
    ylabel('Intensity (A.U.)')
    standardizeFigure


