% prefixes = {'2019-10-22-1Dg11_EfEf3_1','2019-10-23-1Dg11_EfEf3_2','2019-10-23-1Dg11_EfEf3_3',...
%    '2019-10-23-1Dg11_EfEf3_4','2019-10-23-1Dg11_EfEf3_5', '2019-10-24-1Dg11_EfEf3_6'};
% prefixes = {'2019-10-22-1Dg11_EfEf3_1','2019-10-23-1Dg11_EfEf3_2','2019-10-23-1Dg11_EfEf3_3'};

%%%%%
dataType = '1DgW_FFF';
[~, prefixes, ~] = LoadMS2Sets(dataType, 'justPrefixes', 'noCompiledNuclei');

for i = 1:length(prefixes)
    if i ~=1000
   ExportDataForLivemRNA(prefixes{3}, 'nuclearGUI', 'lowbit', 'keepTifs')
        filterMovie(prefixes{i},'tifs')

    filterMovie(prefixes{i},'highPrecision','customFilter','Difference_of_Gaussian_3D', {2,4}, 'saveAsMat', 'nogpu', 'keepPool', 'nWorkers', 20)
    TrackNuclei(prefixes{i}, 'retrack')
    segmentSpots(prefixes{i},10028,'intScale', 2, 'Shadows', 1, 'keepPool', 'fit3D', 'keepProcessedData', 'nuclearMask', 'saveAsMat');
        TrackmRNADynamics(prefixes{i}, 'noRetracking');
        FindAPAxisFullEmbryo(prefixes{i}, 'CorrectAxis')
    end
    AddParticlePosition(prefixes{i},  'yToManualAlignmentPrompt');
    CheckDivisionTimes(prefixes{i}, 'lazy')
    CompileParticles(prefixes{i}, 'SkipAll', 'ApproveAll', 'minBinSize', .3, 'MinParticles', 0, 'yToManualAlignmentPrompt');
end
% 
% addDVStuffToSchnitzCells(dataType)
% plotFracByDlFluo(dataType)
%%%%%%


dataTypes = {'1Dg', '1DgW_FFF', '1DgVW_FFF', '0Dg'};
% dataTypes = {'1Dg', '1Dg-5_FFF', '0Dg'};
for i = 1:length(dataTypes)
%     addDVStuffToSchnitzCells(dataTypes{i})
    plotFracByDlFluo(dataTypes{i}, 'duration');
    if i == 1
        ax1dg =gca;
    else
        ax = gca;
%         if ~isempty(ax.Children)
            copyPlot(ax, ax1dg);
%         end
    end
end 
legend(dataTypes{:});
% ylim([200, 450]);


%%%


% dataTypes = {'1Dg', '1DgW_FFF', '1Dg-5_FFF', '0Dg'};
% dataTypes = {'1Dg-5_FFF', '0Dg'};
% dataTypes = {'1DgVW_FFF'};
for k = 1:length(dataTypes)
    [~, prefixes, ~] = LoadMS2Sets(dataTypes{k}, 'justPrefixes', 'noCompiledNuclei');
    for i= 1:length(prefixes)
%         TrackNuclei(prefixes{i}, 'nWorkers', 1, 'retrack', 'integrate');
%        TrackmRNADynamics(prefixes{i}, 'noRetracking');
       AddParticlePosition(prefixes{i},  'yToManualAlignmentPrompt');
       CompileParticles(prefixes{i}, 'SkipAll', 'ApproveAll', 'minBinSize', .3, 'MinParticles', 0, 'yToManualAlignmentPrompt');
        CompileNuclearProtein(prefixes{i})
    end
    addDVStuffToSchnitzCells(dataTypes{k})
end


%%
nSpots = 1;
dataTypes = {'1Dg', '1DgW_FFF', '1Dg-5_FFF', '0Dg', '1DgVW_FFF'};
for k = 1:length(dataTypes)
    [~, prefixes, ~] = LoadMS2Sets(dataTypes{k}, 'justPrefixes', 'noCompiledNuclei');
    
    for i = 1:length(prefixes)
%         fit3DGaussiansToAllSpots(prefixes{i}, nSpots)
        CompileParticles(prefixes{i}, 'SkipAll', 'ApproveAll', 'minBinSize', .3, 'MinParticles', 0, 'yToManualAlignmentPrompt');
    end
    addDVStuffToSchnitzCells(dataTypes{k})
end
