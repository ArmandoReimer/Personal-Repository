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

%     optionalResults = 'SyntheticEnhancesNoCurationResults';
    optionalResults = '';
    area = 437;
    channel = 1; 
    nPlanes = 1;

    mFig = figure();
    mAx = axes(mFig);    
    
    dataset = 'E1_nocuration';    
%     e1struct = collectData();
%     plotData(dogMax);
%        
    dataset = 'mcp_opt_nocuration';
%     dataset = 'mcp_opt'; 
    mcpStruct = collectData();
%     plotData(mcpStruct.fluoAntSum);
%     plotData(mcpStruct.fluoPostSum);
    plotData(mcpStruct.FluoGauss3DSum);

    dataset = 'noReporter_nocuration';
%     dataset = 'noReporter_opt';
    noReporterStruct = collectData();
    plotData(noReporterStruct.FluoGauss3DSum);
    
%     leg = legend(mAx,'anterior data', 'anterior fit', 'posterior data', 'posterior fit', 'no reporter', 'no reporter fit');
%     leg = legend(mAx,'BcdE1', 'anterior data', 'posterior data', 'no reporter');
%     leg = legend(mAx,'BcdE1', 'no reporter');
    leg = legend(mAx,'reporter', 'no reporter');
    xlabel(mAx,'ln intensity (au)')
    ylabel(mAx,'probability')
    title(mAx,'distribution of trace intensities') 
    hold(mAx,'off')
    
    standardizeFigure(mAx,leg);
    
%% 
    function histStruct = collectData()
               
        d = LoadMS2Sets(dataset,'optionalResults',optionalResults);
        nSets = length(d);
        Prefix = cell(1, nSets);
        histStruct = struct(...
        'fluoMin' ,[],'fluoMinAnt' , [], 'fluoMinPost', [], 'fluo' , [], 'fluoAnt' , [], 'fluoPost' , [],...
        'dog', [], 'dogMax' , [], 'dogAnt' , [], 'dogPost' , [], 'dogMaxAnt' , [], 'dogMaxPost' , [],...
        'fluoSum' ,[], 'fluoAntSum' ,[], 'fluoPostSum',[], 'FluoGauss3D', [], 'FluoGauss3DSum', []);
        
        for dataSet = 1:nSets 
            Prefix = d(dataSet).Prefix;
            if isempty(optionalResults)
                path = ['E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2\',Prefix,'\CompiledParticles.mat'];
            else
                path = ['E:\SyntheticEnhancers\Data\', optionalResults,filesep,Prefix,'\CompiledParticles.mat'];
            end
            data = load(path);
            channel = 1; 
            if iscell(data.CompiledParticles)
                CP = data.CompiledParticles{channel};
            else
                CP = data.CompiledParticles;
            end
   
            for i = 1:length(CP)
                offMin = min(CP(i).Off*nPlanes)*area;
                histStruct.fluoMin = [histStruct.fluoMin, min(CP(i).Fluo) + offMin];
                histStruct.fluo = [histStruct.fluo, CP(i).Fluo + CP(i).Off*nPlanes*area];
                try
                histStruct.dog = [histStruct.dog, CP(i).FluoDog];
                histStruct.dogMax = [histStruct.dogMax, CP(i).FluoDogMax];
                histStruct.dogSum = [histStruct.dog, sum(CP(i).FluoDog)];
                 histStruct.dogMaxSum = [histStruct.dogMax, sum(CP(i).FluoDogMax)];
                end
                histStruct.fluoSum = [histStruct.fluoSum, sum(CP(i).Fluo) + sum(CP(i).Off*nPlanes)*area];
                histStruct.FluoGauss3D = [histStruct.FluoGauss3D, CP(i).FluoGauss3D];
                histStruct.FluoGauss3DSum = [histStruct.FluoGauss3DSum, sum(CP(i).FluoGauss3D)];
                
                
                
                if CP(i).MeanAP < .7 && CP(i).MeanAP > .2
                    histStruct.fluoMinAnt = [histStruct.fluoMinAnt,  min(CP(i).Fluo) + offMin];
                    histStruct.fluoAnt  = [histStruct.fluoAnt,  CP(i).Fluo + CP(i).Off*nPlanes*area];
                    try
                    histStruct.dogAnt = [histStruct.dog, CP(i).FluoDog];
                    histStruct.dogMaxAnt = [histStruct.dogMax, CP(i).FluoDogMax];
                    end
                    histStruct.fluoAntSum = [histStruct.fluoAntSum, sum(CP(i).Fluo) + sum(CP(i).Off*nPlanes)*area];
                end
                if CP(i).MeanAP > .7
                    histStruct.fluoMinPost = [histStruct.fluoMinPost, min(CP(i).Fluo) + offMin];
                    histStruct.fluoPost = [histStruct.fluoPost, CP(i).Fluo+ CP(i).Off*nPlanes*area];
                    try
                    histStruct.dogPost = [histStruct.dog, CP(i).FluoDog];
                    histStruct.dogMaxPost = [histStruct.dogMax, CP(i).FluoDogMax];
                    end
                    histStruct.fluoPostSum = [histStruct.fluoPostSum, sum(CP(i).Fluo) + sum(CP(i).Off*nPlanes)*area];

                end
            end    
        end
        
        reduce = @(x) (x./10) - 100*area; 
        
        
    end

    function plotData(input, varargin)
        if ~isempty(varargin)
            binWidth = varargin{1};
            h = histogram(log(input),'Normalization','probability', 'facealpha', .8);
        else
            h = histogram(log(input), 'Normalization','probability', 'facealpha', .8, 'BinWidth', .3);
        end
        hold on
%         pd = fitdist(h.Data','Normal');
%         y = pdf(pd,sort(h.Data));
%         plot(sort(h.Data),y)     
    end

 
end