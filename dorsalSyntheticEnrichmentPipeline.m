dataType = '1DgW_and_1DgW2xDl';
[~, dbox] = getDorsalFolders;
dbox = [dbox, filesep];

main01_compile_traces(dataType,dbox,'firstNC', 12);
main02_sample_local_protein(dataType, dbox,'max_rad_um', 6,'segmentNuclei', true, 'display_figures', false);
% main03_check_control_selection(dataType, dbox);
main04_make_exploratory_figs(dataType, dbox, 'dorsal-venus', dataType)
