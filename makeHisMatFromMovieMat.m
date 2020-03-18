function hisMat = makeHisMatFromMovieMat(Prefix, varargin)

ProjectionType = 'midsumprojection';
Channels = {{'Dorsal-Venus:Nuclear'}, {'MCP-mCherry'}, {''}};
choosegui = true;

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
nFrames = size(movieMat, 4);


if choosegui
    
    [~, ~, hisMat] = chooseNuclearChannels2(...
        movieMat, 'ProjectionType', ProjectionType,'Channels',Channels,'ReferenceHist', ReferenceHist);
else
    
    for frame= 1:nFrames
        hisMat(:, :, frame) = generateNuclearChannel2(ProjectionType, Channels, ReferenceHist, movieMat, frame);
    end
    
end

hisFile = [PreProcFolder, filesep, Prefix,filesep, Prefix, '_hisMat.mat'];

if whos(var2str(hisMat)).bytes < 2E9
    save(hisFile, 'hisMat', '-v6');
else
    hisMatic = newmatic(hisFile,true,...
        newmatic_variable('hisMat', 'uint8', [ySize, xSize, nFrames], [ySize, xSize, 1]));
    hisMatic.hisMat = hisMat;
end

disp('Nuclear files saved.')

end