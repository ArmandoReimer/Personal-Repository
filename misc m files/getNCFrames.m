function [ncFrames, nc9, nc10, nc11, nc12, nc13, nc14] = getNCFrames(Prefix, resultsFolder)

path = [resultsFolder, filesep, Prefix];

if ~exist([path, filesep, 'ncFrames.mat'], 'file')
    movieDatabaseFolder = getMovieDatabaseFolder;
    [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, nc9, nc10, nc11, nc12, nc13, nc14] = getExperimentDataFromMovieDatabase(Prefix, movieDatabaseFolder);
    ncFrames = [zeros(1,8), nc9, nc10, nc11, nc12, nc13, nc14];
    save([path,filesep,'ncFrames.mat'], 'ncFrames', 'nc9', 'nc10', 'nc11', 'nc12', 'nc13', 'nc14');
else
    load([path,filesep,'ncFrames.mat'], 'ncFrames', 'nc9', 'nc10', 'nc11', 'nc12', 'nc13', 'nc14');
end


end