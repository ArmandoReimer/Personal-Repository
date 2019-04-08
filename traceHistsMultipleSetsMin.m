function traceHistsMultipleSetsMin()

    optionalResults = 'SyntheticEnhancersNoCurationResults';
    area = 437;
    channel = 1; 

    mFig = figure();
    mAx = axes(mFig);    
    
    dataset = 'E1_nocuration';    
    fluoMin = collectData();
    plotData();
       
    dataset = 'mcp_opt_nocuration';
    fluoMin = collectData();
    plotData();
    
    leg = legend(mAx,'e1', 'e1 fit', 'mcp', 'mcp fit');
    xlabel(mAx,'minimum trace fluorescence (au)')
    ylabel(mAx,'frequency')
    title(mAx,'distribution of minimum trace intensities') 
    hold(mAx,'off')
    
    standardizeFigure(mAx,leg);
    
%% 
    function fluoMin = collectData()
        
        d = LoadMS2Sets(dataset, optionalResults);
        nSets = length(d);
        Prefix = cell(1, nSets);
        fluo = [];
        fluoMin = [];
        
        for dataSet = 1:nSets 
            Prefix{dataSet} = d(dataSet).Prefix;
            path = ['E:\SyntheticEnhancers\Data\', optionalResults,filesep,Prefix{dataSet},'\CompiledParticles.mat'];
            data = load(path);
            channel = 1; 
            if iscell(data.CompiledParticles)
                CP = data.CompiledParticles{channel};
            else
                CP = data.CompiledParticles;
            end
   
            for i = 1:length(CP)
                for j = 1:length(CP(i).Frame)
                    off = CP(i).Off(j)*area;
                    fluo = [fluo, CP(i).Fluo(j) + off];
                end
                offMin = min(CP(i).Off)*area;
                fluoMin = [fluoMin, min(CP(i).Fluo) + offMin];
            end    
        end     
    end

    function plotData
        nBins = 15;
        h = histogram(fluoMin,nBins,'Normalization','pdf', 'facealpha', .8,'BinWidth', 30);
        hold on
        pd = fitdist(h.Data','Normal');
        y = pdf(pd,sort(h.Data));
        plot(sort(h.Data),y)     
    end
 
end