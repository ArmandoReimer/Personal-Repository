function traceHistsMultipleSetsMin(mcpData, noRepData)
%  traceHistsMultipleSetsMin()
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
close all;
area = 437;
channel = 1;
nPlanes = 1;
% mFig = figure();
% mAx = axes(mFig);
%     dataset = 'E1_nocuration';

% mcpData = LoadMS2Sets('mcp_opt','optionalResults','');
mcpStruct = collectData(mcpData, 'mcp_opt', '');
% noRepData = LoadMS2Sets('noReporter_opt','optionalResults','');
% noRepData = LoadMS2Sets('noReporter_nocuration','optionalResults','SyntheticEnhancersNoCurationResults');
% noReporterStruct = collectData(noRepData,'noReporter_nocuration','SyntheticEnhancersNoCurationResults' );
noReporterStruct = collectData(noRepData,'noReporter_opt', '' );

histFields = fieldnames(mcpStruct);

% for f = 1:length(histFields)
%     subplot(6,6,f);
%     if contains(histFields{f}, 'dog')
%         wid = .001;
%     else
%         wid = .2;
%     end
%     plotData(mcpStruct.(histFields{f}));
%     plotData(noReporterStruct.(histFields{f}));
%     if f == 1
%         legend('reporter', 'no reporter');
%     end
%     xlabel('log intensity (au)')
%     ylabel('probability')
%     title('distribution of trace intensities')
%     title(histFields{f});
%     if contains(histFields{f}, 'dog')
%         xlim([6.8, 9.5])
%     else
%         xlim([6,10])
%     end
%     ylim([.001, 2])
%     hold('off')
    %     standardizeFigure(gca, leg);
% end

% figure(2)
% plotData(mcpStruct.FluoGauss3DSum, .3);
% plotData(noReporterStruct.FluoGauss3DSum, .3);
% xlabel('log intensity (au)')
% ylabel('probability')
% title('distribution of trace intensities')
% title('FluoGauss3DSum');
% 
%     xlim([6,10.5])
% figure(2)
% plotData(mcpStruct.ampdog3, .0001);
% plotData(noReporterStruct.ampdog3, .0005);
% xlabel('log intensity (au)')
% ylabel('probability')
% title('distribution of trace intensities')
% title('amp dog 3');
% xlim([14.595,14.6055]);
% figure(3)
% plotData(mcpStruct.ampdog3Max, .005);
% plotData(noReporterStruct.ampdog3Max, .005);
% xlabel('log intensity (au)')
% ylabel('probability')
% title('distribution of trace intensities')
% title('amp dog 3 Max');
figure(4)
plotData(mcpStruct.ampdog3Sum,  mcpStruct.totalEllipsesNC12);
plotData(noReporterStruct.ampdog3Sum, mcpStruct.totalEllipsesNC12);
xlabel('log intensity (au)')
ylabel('probability')
title('distribution of trace intensities')
title('amp dog 3 Sum');
leg = legend('MCP-GFP with MS2', 'MCP-GFP alone');
standardizeFigure(gca, leg);


hold('off')
%%
function histStruct = collectData(d, dataset, optionalResults)

%         d = LoadMS2Sets(dataset,'optionalResults',optionalResults);
nSets = length(d);
Prefix = cell(1, nSets);
histStruct = struct(...
    'fluoMin' ,[],'fluoMinAnt' , [], 'fluoMinPost', [], 'fluo' , [], 'fluoAnt' , [], 'fluoPost' , [],...
    'dog', [], 'dogMax' , [], 'dogAnt' , [], 'dogPost' , [], 'dogMaxAnt' , [], 'dogMaxPost' , [],...
    'fluoSum' ,[], 'fluoAntSum' ,[], 'fluoPostSum',[], 'FluoGauss3D', [], 'FluoGauss3DSum', [],...
    'dogMaxSum', [], 'FluoGauss3DSumnc12', [], 'FluoGauss3DSumnc11', [], 'ampdog3', [], 'ampdog3Max',[],...
    'ampdog3Sum', [], 'totalEllipsesNC12', []);

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
    nc11 = data.nc11;
    nc12 = data.nc12;
    nc13 = data.nc13;
    histStruct.totalEllipsesNC12 = sum(data.TotalEllipsesAP(:,2));
    for i = 1:length(CP)
        offMin = min(CP(i).Off*nPlanes)*area;
        histStruct.fluoMin = [histStruct.fluoMin, min(CP(i).Fluo) + offMin];
        histStruct.fluo = [histStruct.fluo, CP(i).Fluo + CP(i).Off*nPlanes*area];
        try
            histStruct.dog = [histStruct.dog, CP(i).FluoDog];
            histStruct.dogMax = [histStruct.dogMax, CP(i).FluoDogMax];
            histStruct.dogSum = [histStruct.dog, sum(CP(i).FluoDog)];
            histStruct.dogMaxSum = [histStruct.dogMax, sum(CP(i).FluoDogMax)];
            try
%             histStruct.ampdog3 = [histStruct.ampdog3, CP(i).ampdog3(CP(i).Frame >= nc12 & CP(i).Frame <= nc13)];
            histStruct.ampdog3 = [histStruct.ampdog3, CP(i).ampdog3];
            histStruct.ampdog3Max = [histStruct.ampdog3Max, CP(i).ampdog3Max];
%             histStruct.ampdog3Sum = [histStruct.ampdog3Sum, (sum(CP(i).ampdog3(CP(i).Frame >= nc12 & CP(i).Frame <= nc13)))/totalnc12nuclei];
             histStruct.ampdog3Sum = [histStruct.ampdog3Sum, sum(CP(i).ampdog3(CP(i).Frame >= nc12 & CP(i).Frame <= nc13))];

            end
            
        end
        histStruct.fluoSum = [histStruct.fluoSum, sum(CP(i).Fluo) + sum(CP(i).Off*nPlanes)*area];
        histStruct.FluoGauss3D = [histStruct.FluoGauss3D, CP(i).FluoGauss3D];
        histStruct.FluoGauss3DSum = [histStruct.FluoGauss3DSum, nansum(CP(i).FluoGauss3D)];
        histStruct.FluoGauss3DSumnc12 = [histStruct.FluoGauss3DSumnc12, nansum(CP(i).FluoGauss3D(CP(i).Frame >= nc12 & CP(i).Frame <= nc13))];
        histStruct.FluoGauss3DSumnc11 = [histStruct.FluoGauss3DSumnc11, sum(CP(i).FluoGauss3D(CP(i).Frame >= nc11 & CP(i).Frame <= nc12))];
        
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
%         histStruct.dog = reduce(histStruct.dog);
%         histStruct.dogMax = reduce(histStruct.dogMax);

end


end

function plotData(input, varargin)
    input(~isreal(input)) = NaN;
    input = real(input);
    input(input==0) = NaN;
     totalEllipses = varargin{1};
% if ~isempty(varargin)
%     binWidth = varargin{1};
%     h = histogram(log(input),'Normalization','count', 'facealpha', .8,'BinWidth', binWidth);
% else
%     h = histogram(log(input), 'Normalization','count', 'facealpha', .8, 'BinWidth', .5);
    [counts, edges] = histcounts(log(input), 'Normalization','count', 'BinWidth', .5);
    counts = counts / sum(totalEllipses);
    histogram('BinEdges',edges,'BinCounts',counts, 'facealpha', .8)
%     bar(bin,N);
%     h.Values = h.Values / sum(totalEllipses);
% end
% set(gca,'YScale','log');
% set(gca,'XScale','log');
hold on
% try
%     pd = fitdist(h.Data','Normal');
%     y = pdf(pd,sort(h.Data));
%     plot(sort(h.Data),y)
% end

end