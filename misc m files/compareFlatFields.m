%% load the images
dboxpath = getDorsalFolders;
lifdir = dir([dboxpath, 'flat fields', filesep, 'FF*.lif']);
ffmat = [];
for i = 1:length(lifdir)
    LIFPath = [dboxpath, 'flat fields', filesep,lifdir(i).name];
    LIFImages{i} = bfopen(LIFPath);
    ffims{i} = double(LIFImages{1, i}{1,1}{1,1});
    ffmat(:, :, i) = ffims{i};
end
save('C:\Users\owner\Dropbox\DorsalSyntheticsDropbox\flat fields\ffmatmat', 'ffmat')
%% Smooth the images
for i = 1:length(ffims)
        ffsmooth{i} = imgaussfilt(ffims{i}, 512, 'Padding', 'symmetric');
end

%normalize the flat fields
for i = 1:length(ffsmooth)  
    ffnorm{i} = ffsmooth{i} ./ max(max(ffsmooth{i}));
end
%% Inspect the flat fields
for i = 1:length(ffsmooth)
    figure(1)
    imshow(ffnorm{i},[]); 
    figure(2)
    histogram(ffnorm{i});
    drawnow;
    waitforbuttonpress;
end

%% compare to high accumulation and averaged flat field
goodlif = bfopen('C:\Users\owner\Desktop\FF_HyD1_DlV_20200212_highaveragetest.lif');
goodff = [];

for position = 1:length(goodlif)
    for frame = 1:length(goodlif{position,1})
        goodff(position, frame, :, :) = double(goodlif{position,1}{frame,1}); %i might have frame and position mixed up. woops.
    end
end

goodtotalave0 = squeeze(mean(goodff, [1, 2]));
% goodtotalave=  imgaussfilt(goodtotalave0, 2, 'Padding', 'symmetric');
% filtered_image = gaussianbpf(goodtotalave,10,1024);
% goodtotalave = goodtotalave - min(goodtotalave(:));
goodtotalave = goodtotalave ./ max(goodtotalave(:));
goodtotalave0 = goodtotalave0 ./ max(goodtotalave0(:));
figure(3)
histogram(goodtotalave0);
figure(4)
imshow(goodtotalave, []);

smoothness = [];
for i = 1:5:510
    filtered_image = gaussianbpf(goodtotalave,i, 512);
    smoothness(i) = std(std(double(filtered_image))) ./ mean(mean(double(filtered_image)));
%     pause(.1)
end
plot(1:length(smoothness), smoothness)




%%
posave = squeeze(mean(goodff, 2));
figure()
tiledlayout('flow')
for position = 1:size(posave, 1)
    smoothpos(position,:,:) = imgaussfilt(squeeze(posave(position, :, :)), 3, 'Padding', 'symmetric');
    smoothpos(position,:,:)  = smoothpos(position,:,:) ./ squeeze(max(max(smoothpos(position,:,:))));
    nexttile;
    imshow(squeeze(smoothpos(position, :, :)), []);
%     histogram(smoothpos)
end
