dataTypes = { '1Dg_2xDl', '1Dg-8D_FFF',...
    '1DgW_2x_Leica', '1DgW_FFF', '1Dg11_FFF',...
    '1Dg-5_FFF', '1DgVW_FFF', '1Dg_og'};

warning('off', 'parallel:cluster:DepfunError');


for i = 1:length(dataTypes)
    
    %     batch(@main02_sample_local_protein, 1, {dataTypes{i}, DropboxFolder,'max_rad_um', 6,...
    %         'shouldSegmentNuclei', true, 'display_figures', false, 'ignoreQC', true, 'askToOverwrite', false})
    
    %1, 7 done. 
    
    %might be useful later
    %data = fetchOutputs(job)
    
    
    [~, ~, prefixes] = getDorsalPrefixes(dataTypes{8});
    jobCell = {};
    for k= 1:length(prefixes)
        
%         batch(@ExportDataForLivemRNA, 1, {prefixes{k},  'exportNuclearProjections', false, 'ignoreCh3', true});
%             batch(@makeMovieMatChannels, 1, {prefixes{k}});
            jobCell{k} = batch(@filterMovie, 0, {prefixes{k}, 'Tifs', 'nWorkers', 1});
    end
    
end

% batch(@TrackNuclei, 0, 'Pool', 20, {prefixes{k}, 'Tifs', 'nWorkers', 20});


% end
