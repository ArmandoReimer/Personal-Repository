
% imPath = 'E:\Armando\p2p_opt_5\2018-08-23-p2p_mcp_opt_5_114_z08_ch01.tif';
% im = imread(imPath);
% scale = 70/212;
% % scale = (35/212);
% ds_im = (1/scale)*imresize(im, scale); %imresize averages local pixels, so multiplying by 
% %the scale factor should bring the intensities up to some quantity that'll
% %preserve the per micron intensity 
% 
% figure()
% subplot(1,2,1)
% imshow(im,[])
% subplot(1,2,2)
% imshow(ds_im,[])
% 
% res = length(im);
% ds_res = length(ds_im);
% snip = im(round(res - (res/10)): res, 1:round(res/10));
% ds_snip = ds_im(round(ds_res - (ds_res/10)): ds_res, 1:round(ds_res/10));
% figure()
% subplot(1,2,1)
% imshow(snip,[])
% subplot(1,2,2)
% imshow(ds_snip,[])


scale = 70/212;

[SourcePath,FISHPath,DefaultDropboxFolder,MS2CodePath, PreProcPath, configValues, movieDatabasePath]=...
    DetermineLocalFolders;
prefix = '2018-08-31-1A3v7L16_mcp_opt_12ds';
prepath = [PreProcPath,filesep,prefix];
d = dir([prepath, filesep,'*.tif']);

for i = 1:length(d)

    impath = [prepath,filesep, d(i).name];
    im = imread(impath);
%     ds_im = (1/scale)*imresize(im, scale, 'Antialiasing', false);
    ds_im = imresize(im, scale, 'Antialiasing', false);
    imwrite(ds_im, impath);
    
    if i == 1
      n_rows = size(ds_im,1);
      n_cols = size(ds_im,2);
    end
    
end


FIpath = ['E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2', filesep,prefix,filesep,'FrameInfo.mat'];
load(FIpath)
nframes = length(FrameInfo);
newSize = orgSize*(length(im) / n_rows);
for j = 1:nframes
    FrameInfo(j).LinesPerFrame = n_rows;
    FrameInfo(j).PixelsPerLine = n_cols;
    FrameInfo(j).PixelSize = newSize;
end
save(FIpath)

filterMovie(Prefix12ds,[],'highPrecision','customFilter','Difference_of_Gaussian', {1,1.5},'keepPool')
filterMovie(Prefix12dsnot,[],'highPrecision','customFilter','Difference_of_Gaussian', {3,4},'keepPool')
segmentSpots(Prefix12dsnot, -1,'Shadows', 2, 'intScale', 2, 'IntegralZ', 'autoThresh','keepPool') %10028.7951
segmentSpots(Prefix12ds, -1,'autoThresh''Shadows', 2, 'intScale', 2/3, 'IntegralZ','keepPool') %10071.1645
CompileParticles(PrefixE14, 'ApproveAll', 'MinParticles', 1, 'intArea', 437)

TrackmRNADynamics(Prefix12ds, 0,0)
TrackmRNADynamics(Prefix12dsnot, 0,0)






