tic
[dataFolder, resultsFolder] = getDorsalFolders();
pth = [dataFolder, filesep, 'PreProcessedData',filesep, Prefix, filesep,Prefix];
nch = 3;
nFrames = 237;
nSlices = 16;
nPadding = 2;
NDigits = 3;
xSize =512; ySize = 512;
movieCell = zeros(nch, nSlices, nFrames, xSize, ySize, 'uint16'); % ch z t x y

for ch = 1:nch
            for f = 1:nFrames
                for z = 1:nSlices+nPadding
                    %reminder to squeeze the array before accessing an image
                    movieCell(ch, z, f, :, :) = imread([pth,'_',iIndex(f, NDigits), '_z', iIndex(z, 2), ['_ch', iIndex(ch, 2)], '.tif']);
                end     
            end
end
tifreadtime = toc
tic
pth2 = 'E:\Armando\clocktesttif';
for ch = 1:nch
            for f = 1:nFrames
                for z = 1:nSlices+nPadding
                    %reminder to squeeze the array before accessing an image
                    imwrite(squeeze(movieCell(ch, z, f, :, :)),[pth2, filesep, Prefix,'_',iIndex(f, NDigits), '_z', iIndex(z, 2), ['_ch', iIndex(ch, 2)], '.tif']);
                end     
            end
end
tifwritetime = toc

%%
tic
pthmat = 'E:\Armando\clocktestmat';
% for ch = 1:nch
%             for f = 1:nFrames
%                 for z = 1:nSlices+nPadding
%                     %reminder to squeeze the array before accessing an image
%                     movieCell(ch, z, f, :, :) = save(movieCell(ch, z, f, :, :),[pthmat, filesep, Prefix,'_',iIndex(f, NDigits), '_z', iIndex(z, 2), ['_ch', iIndex(ch, 2)], '.tif']);
%                 end     
%             end
% end

save([pthmat, filesep, 'movieCellsmall.mat'],'movieCell', '-v7.3', '-nocompression');

matwritetime = toc
%%
%%
tic
pthmat = 'E:\Armando\clocktestmat';
% for ch = 1:nch
%             for f = 1:nFrames
%                 for z = 1:nSlices+nPadding
%                     %reminder to squeeze the array before accessing an image
%                     movieCell(ch, z, f, :, :) = save(movieCell(ch, z, f, :, :),[pthmat, filesep, Prefix,'_',iIndex(f, NDigits), '_z', iIndex(z, 2), ['_ch', iIndex(ch, 2)], '.tif']);
%                 end     
%             end
% end

load([pthmat, filesep, 'movieCell.mat'],'movieCell');

matreadtime = toc


