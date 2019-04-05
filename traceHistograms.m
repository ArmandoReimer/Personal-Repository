function traceHistograms(Prefix)
    
    %makes histograms similar to hernan's current bio paper figure S2 I. 
    data = load(['E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2\',Prefix,'\CompiledParticles.mat']);
    channel = 1; 
    CP = data.CompiledParticles{channel};
    area = 437;
    fluo = [];
    offset = [];
   
    for i = 1:length(CP)
        for j = 1:length(CP(i).Frame)
            off = CP(i).Off(j)*area;
            offset = [offset, off];
            fluo = [fluo, CP(i).Fluo(j) + off];
        end
        offMin = min(CP(i).Off)*area;
        offsetMin = [offset, off];
        fluoMin = [fluoMin, min(CP(i).Fluo) + offMin];
    end
    nBins = 20;
    hFig = figure();
    hAx = axes(hFig);
    histogram(hAx, offset,nBins,'Normalization','probability', 'facealpha', .8, 'BinWidth', 30);
    standardizeFigure(hAx, [], 'red', 'fontSize', 14);
    hold(hAx,'on')
    histogram(hAx,fluo,nBins,'Normalization','probability', 'facealpha', .8,'BinWidth', 30);
    standardizeFigure(hAx, [], 'cyan', 'fontSize', 14);
    legend('background', 'spots')
    xlabel('fluorescence (au)')
    ylabel('frequency')
    title('distribution of spot intensities') 
    hold(hAx,'off')
    
    
     fluoMin = [];
    offsetMin = [];
  
    nBins = 15;
    mFig = figure();
    mAx = axes(mFig);
    histogram(mAx, offsetMin,nBins,'Normalization','probability', 'facealpha', .8, 'BinWidth', 30);
    standardizeFigure(mAx, [], 'red', 'fontSize', 14);
    hold(mAx,'on')
    histogram(mAx,fluoMin,nBins,'Normalization','probability', 'facealpha', .8,'BinWidth', 30);
    standardizeFigure(mAx, [], 'cyan', 'fontSize', 14);
    legend(mAx, 'background', 'spots')
    xlabel(mAx,'minimum trace fluorescence (au)')
    ylabel(mAx,'frequency')
    title(mAx,'distribution of minimum trace intensities') 
    hold(mAx,'off')
    
%     histogram(fluo./offset,nBins,'Normalization','probability', 'facealpha', .8);
%     standardizeFigure(gca, [], 'red', 'fontSize', 14);
end
