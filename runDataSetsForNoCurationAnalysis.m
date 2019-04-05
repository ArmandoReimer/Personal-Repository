function runDataSetsForNoCurationAnalysis(dataset)


    [~, Prefix] = LoadMS2Sets(dataset);

    for i = 3:length(Prefix)
        if i == 3
        filterMovie(Prefix{i}, 'keepPool',...
            'optionalResults', 'SyntheticEnhancersNoCurationResults',...
            'nWorkers', 12, 'highPrecision')
        end
        segmentSpots(Prefix{i}, 1022, 'Shadows', 2, 'keepPool', 'intScale', 2,...
            'optionalResults', 'SyntheticEnhancersNoCurationResults',...
            'nWorkers', 12, 'fit3D', 'keepProcessedData')
        TrackmRNADynamics(Prefix{i},'optionalResults', 'SyntheticEnhancersNoCurationResults','noRetracking')
        AddParticlePosition(Prefix{i}, 'optionalResults', 'SyntheticEnhancersNoCurationResults', 'yToManualAlignmentPrompt')
        CompileParticles(Prefix{i}, 'SkipAll','ApproveAll',...
            'minParticles', 1, 'intArea', 437, 'optionalResults', 'SyntheticEnhancersNoCurationResults','yToManualAlignmentPrompt')
    end
    
end