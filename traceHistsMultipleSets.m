function traceHistsMultipleSets()

    close all;
    
    dataset = 'E1_nocuration';
    area = 437;
    channel = 1; 
    
    if ischar(dataset)
        d = LoadMS2Sets(dataset);
    else
        d = dataset; %this allows you to pass the data directly to the script,
        %bypassing the need to call loadms2sets
    end
    
    nSets = length(d);
    Prefix = cell(1, nSets);
    fluo = [];
    fluoMin = [];
    
    for dataSet = 1:nSets
        
        Prefix{dataSet} = d(dataSet).Prefix;
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
                fluo = [fluo, CP(i).Fluo(j) + off];
            end
            offMin = min(CP(i).Off);
            fluoMin = [fluoMin, min(CP(i).Fluo) + offMin];
        end    
        
    end
    
    nBins = 20;
    hFig = figure();
    hAx = axes(hFig);
    h = histogram(hAx,fluo,nBins,'Normalization','pdf', 'facealpha', .8,'BinWidth', 30);
    hold on
    pd = fitdist(h.Data','Normal');
    y = pdf(pd,sort(h.Data));
    plot(sort(h.Data),y,'r','LineWidth',2)
    xlabel('fluorescence (au)')
    ylabel('frequency')
    title('distribution of spot intensities') 
    
    dataset = 'mcp_opt_nocuration';
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
    fluoMin = [];
    
    for dataSet = 1:nSets
        
        Prefix{dataSet} = d(dataSet).Prefix;
        data = load(['E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2\',Prefix{dataSet},'\CompiledParticles.mat']);
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
    
    h = histogram(hAx,fluo,nBins,'Normalization','pdf', 'facealpha', .8,'BinWidth', 30);
    hold on
    pd = fitdist(h.Data','Normal');
    y = pdf(pd,sort(h.Data));
    plot(sort(h.Data),y,'r','LineWidth',2)
    legend('e1 data', 'e1 fit', 'mcp data', 'mcp fit');

    hold(hAx,'off')
    
%     
%     
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dataset = 'E1_nocuration';
%     area = 437;
%     channel = 1; 
%     
%     if ischar(dataset)
%         d = LoadMS2Sets(dataset);
%     else
%         d = dataset; %this allows you to pass the data directly to the script,
%         %bypassing the need to call loadms2sets
%     end
%     
%     nSets = length(d);
%     Prefix = cell(1, nSets);
%     fluo = [];
%     fluoMin = [];
%     
%     for dataSet = 1:nSets
%         
%         Prefix{dataSet} = d(dataSet).Prefix;
%         data = load(['E:\SyntheticEnhancers\Data\SyntheticEnhancersNoCurationResults\',Prefix{dataSet},'\CompiledParticles.mat']);
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
%             fluoMin = [fluoMin, min(CP(i).Fluo) + offMin];
%         end    
%         
%     end
%     
%     nBins = 15;
%     mFig = figure();
%     mAx = axes(mFig);
%     h = histogram(fluoMin,nBins,'Normalization','pdf', 'facealpha', .8,'BinWidth', 30);
%     hold on
%     pd = fitdist(h.Data','Normal');
%     y = pdf(pd,sort(h.Data));
%     plot(sort(h.Data),y,'r','LineWidth',2)
%     
%     
%     dataset = 'mcp_opt_nocuration';
%     area = 437;
%     channel = 1; 
%   
%     
%     if ischar(dataset)
%         d = LoadMS2Sets(dataset);
%     else
%         d = dataset; %this allows you to pass the data directly to the script,
%         %bypassing the need to call loadms2sets
%     end
%     
%     nSets = length(d);
%     Prefix = cell(1, nSets);
%     fluo = [];
%     fluoMin = [];
%     
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
%     
%     h = histogram(hAx,fluo,nBins,'Normalization','pdf', 'facealpha', .8,'BinWidth', 30);
%     hold on
%     pd = fitdist(h.Data','Normal');
%     y = pdf(pd,sort(h.Data));
%     plot(sort(h.Data),y,'r','LineWidth',2)
% 
%     
%     
%     
%     
%     
%     
%     legend(mAx,'e1', 'e1 fit', 'mcp', 'mcp fit')
%     xlabel(mAx,'minimum trace fluorescence (au)')
%     ylabel(mAx,'frequency')
%     title(mAx,'distribution of minimum trace intensities') 
%     hold(mAx,'off')
% 
% end