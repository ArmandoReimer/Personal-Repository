%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function traceHistsMultipleSetsMin()

    optionalResults = 'SyntheticEnhancersNoCurationResults';
    
    area = 437;
    channel = 1; 

    dataset = 'E1_nocuration'; 
    d = LoadMS2Sets(dataset, optionalResults);

    
    nSets = length(d);
    Prefix = cell(1, nSets);
    fluo = [];
    fluoMin = [];
    
    collectData(['E:\SyntheticEnhancers\Data\SyntheticEnhancersNoCurationResults\',Prefix{dataSet},'\CompiledParticles.mat']);
%     for dataSet = 1:nSets
%         
%         Prefix{dataSet} = d(dataSet).Prefix;
%         data = load(['E:\SyntheticEnhancers\Data\SyntheticEnhancersNoCurationResults\',Prefix{dataSet},'\CompiledParticles.mat']);
%         if iscell(data.CompiledParticles)
%             CP = data.CompiledParticles{channel};
%         else
%             CP = data.CompiledParticles;
%         end
%    
%         for i = 1:length(CP)
%             for j = 1:length(CP(i).Frame)
%                 off = CP(i).Off(j)*area;
%                 fluo = [fluo, CP(i).Fluo(j) + off];
%             end
%             offMin = min(CP(i).Off);
%             fluoMin = [fluoMin, min(CP(i).Fluo) + offMin]; %#ok<AGROW>
%         end    
%         
%     end
    
    nBins = 15;
    mFig = figure();
    mAx = axes(mFig);
    h = histogram(fluoMin,nBins,'Normalization','pdf', 'facealpha', .8,'BinWidth', 30);
    hold on
    pd = fitdist(h.Data','Normal');
    y = pdf(pd,sort(h.Data));
    plot(sort(h.Data),y)
    
    
    dataset = 'mcp_opt_nocuration';
    d = LoadMS2Sets(dataset, optionalResults);

    nSets = length(d);
    Prefix = cell(1, nSets);
    fluo = [];
    fluoMin = [];
    
    collectData(['E:\SyntheticEnhancers\Data\SyntheticEnhancersNoCurationResults\',Prefix{dataSet},'\CompiledParticles.mat']);
%     for dataSet = 1:nSets
%         
%         Prefix{dataSet} = d(dataSet).Prefix;
%         data = load(['E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2\',Prefix{dataSet},'\CompiledParticles.mat']);
%         channel = 1; 
%         if iscell(data.CompiledParticles)
%             CP = data.CompiledParticles{channel};
%         else
%             CP = data.CompiledParticles;
%         end
%    
%         for i = 1:length(CP)
%             for j = 1:length(CP(i).Frame)
%                 off = CP(i).Off(j)*area;
%                 fluo = [fluo, CP(i).Fluo(j) + off];
%             end
%             offMin = min(CP(i).Off)*area;
%             fluoMin = [fluoMin, min(CP(i).Fluo) + offMin];
%         end    
%         
%     end
    
    m = histogram(mAx,fluoMin,nBins,'Normalization','pdf', 'facealpha', .8,'BinWidth', 30);
    hold on
    pd = fitdist(m.Data','Normal');
    y = pdf(pd,sort(m.Data));
    plot(sort(m.Data),y)
    
    legend(mAx,'e1', 'e1 fit', 'mcp', 'mcp fit')
    xlabel(mAx,'minimum trace fluorescence (au)')
    ylabel(mAx,'frequency')
    title(mAx,'distribution of minimum trace intensities') 
    hold(mAx,'off')
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function collectData(path)  
        for dataSet = 1:nSets 
            Prefix{dataSet} = d(dataSet).Prefix;
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
 
end