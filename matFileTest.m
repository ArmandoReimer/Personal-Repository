matObj = matfile('E:\DorsalSynthetics\Data\PreProcessedData\2020-01-31-1Dg11_EfEfEf_1\2020-01-31-1Dg11_EfEfEf_1_movieCell.mat');

'1 image'
tic
small = squeeze(matObj.movieCell(1, 1, 1, :, :));
toc

'18 images'
tic
small = squeeze(matObj.movieCell(1, :, 1, :, :));
toc

'100 images'
tic
small = squeeze(matObj.movieCell(1, 1:2, 1:50, :, :));
toc

'900 images'
tic
small = squeeze(matObj.movieCell(1, 1:18, 1:50, :, :));
toc
