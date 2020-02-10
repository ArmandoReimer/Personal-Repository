function makeAllMovieMats(dataType)

nWorkers = 1;
[~, prefixes,~] = LoadMS2Sets(dataType, 'justPrefixes', 'noCompiledNuclei');

[~, resultsFolder] = getDorsalFolders;

[~,~,~,~, PreProcPath,~, ~, ~,~,~,~,~, ~, ~, movieDatabase]...
    = readMovieDatabase(prefixes{1});

for i = 1:length(prefixes)
    try
load([resultsFolder, filesep, prefixes{i}, filesep, 'FrameInfo.mat'], 'FrameInfo')

[~, ~, ~, ~, ~, ~, Channel1, Channel2, ~, ~, ~, ~, ~, ...
    ~, ~, ~, ~, ~, ~, ~, Channel3, ~, ~] =...
    getExperimentDataFromMovieDatabase(prefixes{i}, movieDatabase);

Channels = {Channel1{1}, Channel2{1}, Channel3{1}};


makeMovieMats(prefixes{i}, PreProcPath, nWorkers, FrameInfo, 'noLoad');
clear ans;
catch
    disp(['failed to do this prefix:  ', prefixes{i}]);
end
    
end

end