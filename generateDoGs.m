function generateDoGs(Prefix, thresh, show,save)
try
    parpool;
catch
end
%%    
%Get the relevant folders now:
[SourcePath,FISHPath,DropboxFolder,MS2CodePath,PreProcPath]=...
    DetermineLocalFolders(Prefix);

%Figure out what type of experiment we have
[XLSNum,XLSTxt]=xlsread([DropboxFolder,filesep,'MovieDatabase.xlsx']);
DataFolderColumn=find(strcmp(XLSTxt(1,:),'DataFolder'));
ExperimentTypeColumn=find(strcmp(XLSTxt(1,:),'ExperimentType'));
Channel1Column=find(strcmp(XLSTxt(1,:),'Channel1'));
Channel2Column=find(strcmp(XLSTxt(1,:),'Channel2'));

% Convert the prefix into the string used in the XLS file
Dashes = strfind(Prefix, '-');
PrefixRow = find(strcmp(XLSTxt(:, DataFolderColumn),...
    [Prefix(1:Dashes(3)-1), '\', Prefix(Dashes(3)+1:end)]));
if isempty(PrefixRow)
    PrefixRow = find(strcmp(XLSTxt(:, DataFolderColumn),...
        [Prefix(1:Dashes(3)-1), '/', Prefix(Dashes(3)+1:end)]));
    if isempty(PrefixRow)
        error('Could not find data set in MovieDatabase.XLSX. Check if it is defined there.')
    end
end

ExperimentType=XLSTxt(PrefixRow,ExperimentTypeColumn);

if strcmp(ExperimentType,'1spot')
    NChannels=1;
elseif strcmp(ExperimentType,'2spot')
    NChannels=1;
elseif strcmp(ExperimentType,'2spot1color')
    NChannels=1;
elseif strcmp(ExperimentType,'2spot2color')
    NChannels=2;
elseif strcmp(ExperimentType,'inputoutput')
    NChannels=1;
else
    error('Experiment type not recognized in MovieDatabase.XLSX')
end

if ~exist('Thresholds')
    Thresholds=ones(1,NChannels)*inf;
else
    if length(Thresholds)~=NChannels
        error('Number of channels in movie does not match number of thresholds input')
    end
end
HyphenPositionR = find(Prefix == '-');
DateFolderS = Prefix(1 : HyphenPositionR(3)-1);
LineFolderS = Prefix(HyphenPositionR(3)+1 : end);
Folder = [SourcePath, filesep, DateFolderS, filesep, LineFolderS];
%Determine whether we're dealing with 2-photon data from Princeton or LSM
%data. 2-photon data uses TIF files. In LSM mode multiple files will be
%combined into one.
DTIF=dir([Folder,filesep,'*.tif']);
DLSM=dir([Folder,filesep,'*.lsm']);
DLIF=dir([Folder,filesep,'*.lif']);
DLAT=dir([Folder,filesep,'*_Settings.txt']);

%%
%Here I want to load each of the tifs and iterate through them, generating
%dog images in each iteration


    %Load the data
im_stack = {};
for j = 1:10-1 %For a full analysis, i'll run this to length(DTIF)
    fname = [Folder, filesep, DTIF(j).name];
    info = imfinfo(fname);
    num_images = numel(info);
    for i = 1:num_images
        im_stack{j, i} = imread(fname, i, 'Info', info);
    end
end
OutputFolder1=[FISHPath,filesep,Prefix,'_',filesep,'MYCODEdogsMYCODE'];
OutputFolder2=[FISHPath,filesep,Prefix,'_',filesep,'MYCODEsegsMYCODE'];

mkdir(OutputFolder1)
mkdir(OutputFolder2)
%%
%DoG Stuff
%filterSize >> sigma 2 > sigma 1. these values should be good for a first
%pass.
pixelSize = 100; %nm
sigma1 = 150 / pixelSize;
sigma2 = 250 / pixelSize;
filterSize = 150 /pixelSize; 
neighb = 3000 / pixelSize; %This should work for a first pass and shouldn't fail on sisters. 20 = 2um
thr = thresh;
dog_stack  = {};
all_frames = {};
for i = 1:10-1 %Will change this to length(DTIF)-1 for full analysis
    for j = 1:size(im_stack,2) %z-slices
        im = im_stack{i,j};
        %filterSize >> sigma 2 > sigma 1. these values should be good for a first pass.
        dog_stack{i,j} = conv2(single(im), single(fspecial('gaussian',filterSize, sigma1) - fspecial('gaussian',filterSize, sigma2)),'same');
        if save
            dog_name = ['DOG_',Prefix,'_',iIndex(i,3),'_z',iIndex(j,2),'.tif'];
            imwrite(uint16(dog_stack{i,j}), [OutputFolder1,filesep,dog_name])
        end
        %commented out for speed
        dog = dog_stack{i,j}(10:end-10, 10:end-10);
        im = im(10:end-10, 10:end-10);
        if show
            figure(1)
            imshow(im,[]);
        end
        thrim = dog>thr;
        [im_label, n_spots] = bwlabel(thrim); 
        temp_particles = {};
        rad = 2000 / pixelSize;
        for k = 1:n_spots
            [r,c] = find(im_label==k);

            %Find spot centroids in the actual image by hunting for absolute maxima in
            %neighborhoods around spots that were just located

            possible_cent = [];
            pcentloc = {};
            cent = [];
            cent_intensity = 0;
            for o = 1:2*neighb
                for p = 1:2*neighb
                    if r(1) - neighb + o > 0 && c(1) - neighb + p > 0 && r(1) - neighb + o < size(im,1)  && c(1) - neighb + p < size(im,2)
                        possible_cent(o,p) = im(r(1)-neighb+o, c(1)-neighb+p);
                        pcentloc{o,p} = [r(1)-neighb+o, c(1)-neighb+p];
                    end
                end
            end
            if ~isempty(possible_cent)
                [inten, index] = max(possible_cent(:));
                [row, col] = ind2sub(size(possible_cent),index);
                cent_y = pcentloc{row,col}(1); 
                cent_x = pcentloc{row,col}(2);
               % temp_particles = [temp_particles,[0, cent_x, cent_y, 0, 0]];
               if show 
                    ellipse(neighb/2,neighb/2,0,cent_y,cent_x,'r');
               end
%                 try
%                     %Fit a single 2D Gaussian
%                     snip = im(cent_y-rad:cent_y+rad, cent_x-rad: cent_x+rad);
%                     [f1, res1, f2, res2] = fitGausses(snip);
%                     if res1/res2 > 1.5
%                         temp_particles = [temp_particles,[f1(1), f1(2), f1(4), f1(5), 0]];
%                     else
%                         temp_particles = [temp_particles,[f2(1), f2(2), f2(4), f2(11), 0]];
%                         temp_particles = [temp_particles,[f1(6), f1(7), f1(9), f1(11),1]];
%                     end
%                 catch
%                 end
                if cent_y - rad > 1 && cent_y - rad > 1 && cent_x - rad > 1 && cent_x - rad > 1 && cent_y + rad < size(im, 1) && cent_x + rad < size(im,2)
                    snip = im(cent_y-rad:cent_y+rad, cent_x-rad: cent_x+rad);
%                      [f1, res1, f2, res2] = fitGausses(snip);
                    [f1, res1] = fitGausses(snip,show);
                    c_x = f1(2) - rad + cent_x;
                    c_y = f1(4) - rad + cent_y;
                    int_x = [round(c_x - f1(3)), round(c_x + f1(3))];
                    int_y = [round(c_y - f1(5)), round(c_y + f1(5))];
                    fluor = 0;
                    if int_x(1) > 1 && int_y(1) > 1 && int_x(2) < size(im,2) && int_y(2) < size(im,1)
                        for w = int_x(1):int_x(2)
                            for v = int_y(1): int_y(2)
                                fluor = fluor + double(im(v,w));
                            end
                        end
                        temp_particles = [temp_particles,double([fluor, c_x, c_y, f1(6)])];
                    end
                end
            end
            if k == n_spots && save
                seg_name = ['SEG_',Prefix,'_',iIndex(i,3),'_z',iIndex(j,2),'.tif'];
                saveas(gcf,[OutputFolder2,filesep,seg_name]);
            end
        end
        all_frames{i,j} = temp_particles;
    end
end

%%

clear im_stack
clear dog_stack
n = 1;
nframes = size(all_frames,1);
nz = size(all_frames,2);
for i = 1:nframes %frames
    for j = 1:nz %z-slices
         for k = 1:length(all_frames{i,j}) %spots within particular image
             if ~isempty(all_frames{i,j}{k})
                 Particles(n).Intensity(1) = all_frames{i,j}{k}(1);
                 Particles(n).x(1) = all_frames{i,j}{k}(2);
                 Particles(n).y(1) = all_frames{i,j}{k}(3);
                 Particles(n).Offset(1) = all_frames{i,j}{k}(4);
%                  Particles(n).Sister(1) = all_frames{i,j}{k}(5);
                 Particles(n).z(1) = j;
                 Particles(n).t(1) = i;
                 Particles(n).r = 0;
                 n = n + 1;
             end
         end
    end
end
% z tracking
changes = 1;
while changes ~= 0
    changes = 0;
    i = 1;
    for n = 1:nframes %frame of interest   
        i = i + length(Particles([Particles.t] == (n - 1) ));
        for j = i:i+length(Particles([Particles.t] == n)) - 1
            for k = j+1:i+length(Particles([Particles.t] == n)) - 1
                dist = sqrt( (Particles(j).x(end) - Particles(k).x(end))^2 + (Particles(j).y(end) - Particles(k).y(end))^2); 
                if dist < neighb && Particles(j).z(end) ~= Particles(k).z(end)
                    Particles(j).Intensity = [Particles(j).Intensity, Particles(k).Intensity];
                    Particles(j).x = [Particles(j).x, Particles(k).x];
                    Particles(j).y = [Particles(j).y, Particles(k).y];
                    Particles(j).z = [Particles(j).z, Particles(k).z];
                    Particles(j).Offset = [Particles(j).Offset, Particles(k).Offset];
                    Particles(k).r = 1;
                    changes = changes + 1;
                end
            end
        end
    end
    Particles = Particles([Particles.r]~=1);
end


%pick the brightest z-slice
for i = 1:length(Particles)
    [~, max_index] = max(Particles(i).Intensity);
    Particles(i).Intensity = Particles(i).Intensity(max_index);
    Particles(i).x = Particles(i).x(max_index);
    Particles(i).y = Particles(i).y(max_index);
    Particles(i).z = Particles(i).z(max_index);
    Particles(i).Offset = Particles(i).Offset(max_index);
end

%time tracking
changes = 1;
while changes ~= 0
    changes = 0;
    for n = 1:length(Particles)-1 %particle of interest
        for j = n+1:length(Particles) %particle to compare to
            if Particles(n).t(end) == (Particles(j).t(end) -  1)
                dist = sqrt( (Particles(n).x(end) - Particles(j).x(end))^2 + (Particles(n).y(end) - Particles(j).y(end))^2); 
                if dist < neighb
                    Particles(n).Intensity = [Particles(n).Intensity, Particles(j).Intensity];
                    Particles(n).x = [Particles(n).x, Particles(j).x];
                    Particles(n).y = [Particles(n).y, Particles(j).y];
                    Particles(n).z = [Particles(n).z, Particles(j).z];
                    Particles(n).Offset = [Particles(n).Offset, Particles(j).Offset];
                    Particles(n).t = [Particles(n).t, Particles(j).t];
                    Particles(j).r = 1;
                    changes = changes + 1;
                end
            end
        end
    end
Particles = Particles([Particles.r]~=1);
end

mkdir([DropboxFolder,filesep,Prefix,filesep,'mycode']);
save([DropboxFolder,filesep,Prefix,filesep,'mycode',filesep,'Particles.mat'], 'Particles')
for i = 1:length(Particles)
    if length(Particles(i).t) > 50
        plot(Particles(i).t, Particles(i).Intensity)
        i
        hold on
    end
end

end