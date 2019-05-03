function runDataSetsForNoCurationAnalysis()
    
    lowThresh = 1020;
    highThresh = 1022;
    resultsFolder = 'SyntheticEnhancersNoCurationResults';
    
    [~, mcpoptPrefix] = LoadMS2Sets('mcp_opt_nocuration');
    runAll(mcpoptPrefix);
    
    [~, noReporterPrefix] = LoadMS2Sets('noReporter_nocuration');
    runAll(noReporterPrefix);
%     
%       [~, E1Prefix] = LoadMS2Sets('E1_nocuration');
%     runAll(E1Prefix);
%     
    function runAll(prefixCell)
        for i = 9:length(prefixCell)
            disp(['running dataset: ', num2str(i), ', ',prefixCell{i}])
            if i ~=4
            filterMovie(prefixCell{i}, 'keepPool',...
                'optionalResults', resultsFolder,...
                'nWorkers', 20, 'highPrecision')
            end
            segmentSpots(prefixCell{i}, lowThresh, 'Shadows', 2, 'keepPool', 'intScale', 2,...
                'optionalResults', resultsFolder,'nWorkers', 20, 'keepProcessedData', 'fit3D')
            TrackmRNADynamics(prefixCell{i},'optionalResults',  resultsFolder,'noRetracking')
%                         FindAPAxisFullEmbryo(prefixCell{i}, 'optionalResults',  resultsFolder, 'CorrectAxis')
            AddParticlePosition(prefixCell{i}, 'optionalResults',  resultsFolder, 'yToManualAlignmentPrompt')
            CompileParticles(prefixCell{i}, 'SkipAll','ApproveAll',...
                'minParticles', 1, 'intArea', 437, 'optionalResults',  resultsFolder,'yToManualAlignmentPrompt', 'minBinSize', .3)
        end
    end
end