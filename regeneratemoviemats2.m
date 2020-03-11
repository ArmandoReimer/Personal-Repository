
[~, ProcPath, DropboxFolder, ~, PreProcPath] = DetermineLocalFolders(Prefix);

dataTypes = { '1Dg-8D_FFF', '1Dg_2xDl'};
for i = 1:length(dataTypes)
    [~, ~, prefixes] = getDorsalPrefixes(dataTypes{i});
    for k = 1:length(prefixes)
%         prefixes{k}
%         
%         load([DropboxFolder, filesep, Prefix, filesep, 'FrameInfo.mat'], 'FrameInfo');
% 
%         makeMovieMats(prefixes{k}, PreProcPath, 1, FrameInfo, 'makeMovie', tru.e, 'makeProjs', true)
        ExportDataForLivemRNA(prefixes{k})
        
    end
end