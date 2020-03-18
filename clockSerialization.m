movieFile = 'X:\DorsalSynthetics\Data\PreProcessedData\2019-12-02-1DgVW_EfEfEf_8\2019-12-02-1DgVW_EfEfEf_8_movieCell.mat';

tic
% movieMat = loadMovieMat(movieFile);
movieMat = load('X:\DorsalSynthetics\Data\PreProcessedData\2019-12-02-1DgVW_EfEfEf_8\2019-12-02-1DgVW_EfEfEf_8_movieCell.mat', 'movieCell');
toc
disp('movie mat loaded');

tic
movieMatSerialized = hlp_serialize(movieMat);
toc
disp('moviemat serialized')

tic
save('X:\DorsalSynthetics\movieMatSerialized.mat','movieMatSerialized', '-v6');
toc
disp('moviemat serialized saved')

tic
load('X:\DorsalSynthetics\movieMatSerialized.mat','movieMatSerialized');
toc
disp('moviemat serialized loaded')

tic
movieMatDeserialized  = hlp_deserialize(movieMatSerialized);
toc
disp('moviematserialized deserialized');

isequal(movieMat,movieMatDeserialized)

tic
save('X:\DorsalSynthetics\movieMat.mat','movieMat', '-v6');
toc

tic
load('X:\DorsalSynthetics\movieMat.mat','movieMat');
toc