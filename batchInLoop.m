dataTypes = { '1Dg_2xDl', '1Dg-8D_FFF', '1DgW_2x_Leica', '1DgW_FFF', '1Dg11_FFF', '1Dg-5_FFF', '1DgVW_FFF', '1Dg_og'};

for k = 2:length(dataTypes)
    
    batch(@main02_sample_local_protein, 1, {dataTypes{k}, DropboxFolder,'max_rad_um', 6,...
        'shouldSegmentNuclei', true, 'display_figures', false, 'ignoreQC', true, 'askToOverwrite', false})

end