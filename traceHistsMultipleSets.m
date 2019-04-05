function traceHistsMultipleSets(dataset)

    area = 437;
    channel = 1; 
    
    if ischar(dataset)
        d = LoadMS2Sets(dataset);
    else
        d = dataset; %this allows you to pass the data directly to the script,
        %bypassing the need to call loadms2sets
    end
    
    nSets = length(d);
%     ap = data(1).APbinID;
%     numAPBins = length(ap);
    Prefix = cell(1, nSets);
    fluo = [];
    offset = [];
    fluoMin = [];
    offsetMin = [];
    
    for dataSet = 1:nSets
        
        Prefix{dataSet} = d(dataSet).Prefix;

        
%         data = load(['E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2\',Prefix{dataSet},'\CompiledParticles.mat']);
       data = load(['E:\SyntheticEnhancers\Data\SyntheticEnhancersNoCurationResults\',Prefix{dataSet},'\CompiledParticles.mat']);
        channel = 1; 
        if iscell(data.CompiledParticles)
            CP = data.CompiledParticles{channel};
        else
            CP = data.CompiledParticles;
        end
   
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
        
    end
    
    nBins = 20;
    hFig = figure();
    hAx = axes(hFig);
    
%     h = histogram(hAx, offset,nBins, 'Normalization','pdf','facealpha', .8, 'BinWidth', 30);
%     hold(hAx, 'on')
%     pd = fitdist(h.Data','Normal');
%     y = pdf(pd,sort(h.Data));
%     plot(sort(h.Data),y, 'b', 'LineWidth',2)
%     standardizeFigure(hAx, [], 'red', 'fontSize', 14);
    
    h = histogram(hAx,fluo,nBins,'Normalization','pdf', 'facealpha', .8,'BinWidth', 30);
    pd = fitdist(h.Data','Normal');
    y = pdf(pd,sort(h.Data));
    plot(sort(h.Data),y,'r','LineWidth',2)
%     standardizeFigure(hAx, [], 'cyan', 'fontSize', 14);
    
    legend('background', 'bg fit', 'spots', 'spots fit')
    xlabel('fluorescence (au)')
    ylabel('frequency')
    title('distribution of spot intensities') 
    hold(hAx,'off')


   for i = 1:length(CP)
        offMin = max(CP(i).Off)*area;
        offsetMin = [offset, off];
        fluoMin = [fluoMin, max(CP(i).Fluo) + offMin];
   end
    
    nBins = 15;
%     mFig = figure();
%     mAx = axes(mFig);
%     h = histogram(offsetMin,nBins,'Normalization','pdf', 'facealpha', .8, 'BinWidth', 30);
%     pd = fitdist(h.Data','Normal');
%     y = pdf(pd,sort(h.Data));
%     hold(mAx, 'on')
%     plot(sort(h.Data),y,'b','LineWidth',2)
%     standardizeFigure(mAx, [], 'red', 'fontSize', 14)
    h = histogram(fluoMin,nBins,'Normalization','pdf', 'facealpha', .8,'BinWidth', 30);
    pd = fitdist(h.Data','Normal');
    y = pdf(pd,sort(h.Data));
    plot(sort(h.Data),y,'r','LineWidth',2)
%     standardizeFigure(mAx, [], 'cyan', 'fontSize', 14);
    legend(mAx,'background', 'bg fit', 'spots', 'spots fit')
    xlabel(mAx,'minimum trace fluorescence (au)')
    ylabel(mAx,'frequency')
    title(mAx,'distribution of minimum trace intensities') 
    hold(mAx,'off')

end