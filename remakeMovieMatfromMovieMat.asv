function movieMat = remakeMovieMatfromMovieMat(Prefix, varargin)

shouldIgnoreCh3 = false;

[~,~,~,~, PreProcFolder, ~, ~, ~,Channel1,Channel2,~,...
    Channel3]...
    = readMovieDatabase(Prefix);

%Load the reference histogram for the fake histone channel
load('ReferenceHist.mat', 'ReferenceHist');

if isempty(varargin)
    movieMat = loadMovieMat([PreProcFolder,filesep,Prefix,filesep, Prefix, '_movieMat.mat']);
else
    movieMat = varargin{1};
end

ySize = size(movieMat, 1);
xSize = size(movieMat, 2);
zSize = size(movieMat, 3);
nFrames = size(movieMat, 4);
if numel(size(movieMat)) > 4
    nCh = size(movieMat, 5);
end

if shouldIgnoreCh3 
    movieMat = movieMat(:, :, :, :, 1:2);
end

movieMatCh = movieMat(:, :, :, :, 1:2);

if max(movieMatCh(:)) < 256, dataType = 'uint8'; 
    else dataType = 'uint16'; end
    
movieMat = uint8(movieMat);
    
movieMatic = newmatic([PreProcFolder, filesep, Prefix,filesep, Prefix, '_movieMat.mat'],true,...
    newmatic_variable('movieMat', dataType, [ySize, xSize, zSize, nFrames, nCh], [ySize, xSize, 1, 1, 1]));

movieMatic.movieMat = movieMat;

disp('Movie files saved.')

end
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