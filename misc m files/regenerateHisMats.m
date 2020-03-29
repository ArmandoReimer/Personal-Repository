
[~, ProcPath, DropboxFolder, ~, PreProcPath] = DetermineLocalFolders(Prefix);

dataTypes = {'1Dg-8D_FFF', '1DgW_2x_Leica', '1Dg_2xDl', '1DgW_FFF', '1Dg11_FFF', '1Dg-5_FFF', '1DgVW_FFF', '1Dg_og'};
for i = 1:1
    [~, ~, prefixes] = getDorsalPrefixes(dataTypes{i});
    for k = 1:length(prefixes)
%         prefixes{k}
%         
%         load([DropboxFolder, filesep, Prefix, filesep, 'FrameInfo.mat'], 'FrameInfo');
% 
%         makeMovieMats(prefixes{k}, PreProcPath, 1, FrameInfo, 'makeMovie', true, 'makeProjs', true)
        
          hisFile = [PreProcPath, filesep, prefixes{k}, filesep, prefixes{k}, '_hisMat.mat'];
        hisMat = uint16(loadHisMat(hisFile));
        ySize = size(hisMat, 1); xSize = size(hisMat,2); nFrames = size(hisMat, 3);
        hisMatic = newmatic(hisFile,true,...
            newmatic_variable('hisMat', 'uint16', [ySize, xSize, nFrames], [ySize, xSize, 1]));
        hisMatic.hisMat = hisMat;
        clear hisMatic;
        
    end
end