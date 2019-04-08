function traceHistsMultipleSetsMin()
%  traceHistsMultipleSetsMin(()
%
% DESCRIPTION
% This function generates histograms and gaussian fits a la hernan's
% current biology figure S2 I. No reporter, anterior and posterior
% fluorescence histograms are plotted
%
% ARGUMENTS
% none
%
% OPTIONS
% none
%
% Author (contact): AR
% Created: 4/8/2019 AR
% Last Updated: 4/8/2019 AR 
%
% Documented by: AR

    optionalResults = 'SyntheticEnhancersNoCurationResults';
    area = 437;
    channel = 1; 

    mFig = figure();
    mAx = axes(mFig);    
    
%     dataset = 'E1_nocuration';    
%     [fluoMin, fluoAnt, fluoPost] = collectData();
%     plotData();
       
    dataset = 'mcp_opt_nocuration';
    [~, fluoAnt, fluoPost] = collectData();
    plotData(fluoAnt);
    plotData(fluoPost);
    
    %don't have this data yet
%     dataset = 'noReporter_nocuration';
%     [fluoNoReporter, ~, ~] = collectData();
%     plotData(fluoNoReporter);
%     
%     leg = legend(mAx,'anterior data', 'anterior fit', 'posterior data', 'posterior fit' );
    leg = legend(mAx,'anterior data', 'anterior fit', 'posterior data', 'posterior fit', 'no reporter', 'no reporter fit');
    xlabel(mAx,'minimum trace fluorescence (au)')
    ylabel(mAx,'frequency')
    title(mAx,'distribution of minimum trace intensities') 
    hold(mAx,'off')
    
    standardizeFigure(mAx,leg);
    
%% 
    function [fluoMin, fluoAnt, fluoPost] = collectData()
        
        d = LoadMS2Sets(dataset, optionalResults);
        nSets = length(d);
        Prefix = cell(1, nSets);
        fluoMin = [];
        fluoAnt = [];
        fluoPost = [];
        
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
                offMin = min(CP(i).Off)*area;
                fluoMin = [fluoMin, min(CP(i).Fluo) + offMin];
                if CP(i).MeanAP < .4
                    fluoAnt = [fluoAnt,  min(CP(i).Fluo) + offMin];
                end
                if CP(i).MeanAP > .6
                    fluoPost = [fluoPost, min(CP(i).Fluo) + offMin];
                end
            end    
        end     
    end

    function plotData(input)
        nBins = 15;
        h = histogram(input,nBins,'Normalization','pdf', 'facealpha', .8,'BinWidth', 30);
        hold on
        pd = fitdist(h.Data','Normal');
        y = pdf(pd,sort(h.Data));
        plot(sort(h.Data),y)     
    end
 
end