function runDataSetsForNoCurationAnalysis()
    
    lowThresh = 1007;
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
        for i = 4:length(prefixCell)
            disp(['running dataset: ', num2str(i), ', ',prefixCell{i}])
            if i ~=4
            filterMovie(prefixCell{i}, 'keepPool',...
                'optionalResults', resultsFolder,...
                 'highPrecision', 'nWorkers', 1, 'customFilter', 'Difference_of_Gaussian_3D', {3, 10});
            end
            segmentSpots(prefixCell{i},lowThresh, 'Shadows', 2, 'intScale', 1.5,...
                'optionalResults', resultsFolder,'nWorkers', 8, 'keepProcessedData', 'fit3D')
            TrackmRNADynamics(prefixCell{i},'optionalResults',  resultsFolder,'noRetracking')
%                         FindAPAxisFullEmbryo(prefixCell{i}, 'optionalResults',  resultsFolder, 'CorrectAxis')
            AddParticlePosition(prefixCell{i}, 'optionalResults',  resultsFolder, 'yToManualAlignmentPrompt')
            CompileParticles(prefixCell{i}, 'SkipAll','ApproveAll',...
                'minParticles', 1, 'intArea', 437, 'optionalResults',  resultsFolder,'yToManualAlignmentPrompt', 'minBinSize', .3)
        end
    end
end