function hisMat = makeHisMatFromMovieMat(Prefix)
% dataTypes = { '1Dg_2xDl', '1Dg-8D_FFF', '1DgW_2x_Leica', '1DgW_FFF', '1Dg11_FFF', '1Dg-5_FFF', '1DgVW_FFF', '1Dg_og'};
% 
% for i = 1:length(dataTypes)
%      [~, ~, prefixes] = getDorsalPrefixes(dataTypes{i});
%     for k = 1:length(prefixes)
%         if i~=1 & k~=1
%         makeHisMatFromMovieMat(prefixes{k});
%         end
%     end
% end

ProjectionType = 'midsumprojection';
Channels = {{'Dorsal-Venus:Nuclear'}, {'MCP-mCherry'}, {''}};
choosegui = true;

[~,~,~,~, PreProcFolder, ~, ~, ~,Channel1,Channel2,~,...
    Channel3]...
    = readMovieDatabase(Prefix);

%Load the reference histogram for the fake histone channel
load('ReferenceHist.mat', 'ReferenceHist');


movieMat = loadMovieMat([PreProcFolder,filesep,Prefix,filesep, Prefix, '_movieMat.mat']);

ySize = size(movieMat, 1);
xSize = size(movieMat, 2);
nFrames = size(movieMat, 4);


if choosegui
    
    [~, ~, hisMat] = chooseNuclearChannels2(...
        movieMat, 'ProjectionType', ProjectionType,'Channels',Channels,'ReferenceHist', ReferenceHist);
else
    
    for frame= 1:nFrames
        hisMat(:, :, frame) = generateNuclearChannel2(ProjectionType, Channels, ReferenceHist, movieMat, frame);
    end
    
end


hisMatic = newmatic([PreProcFolder, filesep, Prefix,filesep, Prefix, '_hisMat.mat'],true,...
    newmatic_variable('hisMat', 'uint16', [ySize, xSize, nFrames], [ySize, xSize, 1]));

hisMatic.hisMat = hisMat;

disp('Nuclear files saved.')

end