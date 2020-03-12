dataTypes = { '1Dg_2xDl', '1Dg-8D_FFF', '1DgW_2x_Leica', '1DgW_FFF', '1Dg11_FFF', '1Dg-5_FFF', '1DgVW_FFF', '1Dg_og'};

% for i = 1:length(dataTypes)
    
    %     batch(@main02_sample_local_protein, 1, {dataTypes{i}, DropboxFolder,'max_rad_um', 6,...
    %         'shouldSegmentNuclei', true, 'display_figures', false, 'ignoreQC', true, 'askToOverwrite', false})
    
    [~, ~, prefixes] = getDorsalPrefixes(dataTypes{1});
    
    for k= 1:length(prefixes)
        
        batch(@ExportDataForLivemRNA, 1, {prefixes{k},  'exportNuclearProjections', false});
        
    end
    
% end
