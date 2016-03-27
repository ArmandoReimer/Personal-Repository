function generateDoGs(Prefix)
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
DLAT=dir([Folder,filesep,'..',filesep,'IsLatticeData.txt']);

%%
%Here I want to load each of the tifs and iterate through them, generating
%dog images in each iteration


im_stack = {};
for j = 1:10
    fname = [Folder, filesep, DTIF(j).name];
    info = imfinfo(fname);
    num_images = numel(info);
    for i = 1:num_images
        im_stack{j, i} = imread(fname, i, 'Info', info);
    end
end
%%
%DoG Stuff
%filterSize >> sigma 2 > sigma 1. these values should be good for a first pass.
sigma1 = 1.5;
sigma2 = 2.5;
filterSize = 15; 
neighb = 10; %This should work for a first pass and shouldn't fail on sisters.
thr = 250;

dog_stack  = {};
all_frames = {};
for i = 1:10
    for j = 1:size(im_stack,2)
        im = im_stack{i,j};
        %filterSize >> sigma 2 > sigma 1. these values should be good for a first pass.
        dog_stack{i,j} = conv2(single(im), single(fspecial('gaussian',filterSize, sigma1) - fspecial('gaussian',filterSize, sigma2)),'same');
        dog_name = ['DOG_',Prefix,'_',iIndex(i,3),'_z',iIndex(j,2),'.tif'];
        imwrite(uint16(dog_stack{i,j}), [FISHPath,filesep,Prefix,'_',filesep,'MYCODEpreanalysisMYCODE',filesep,dog_name])
        imshow(im,[]);
        dog = dog_stack{i,j};
        thrim = dog>thr;
        bw = im2bw(thrim);
        [im_label, n_spots] = bwlabel(bw); 
        temp_particles = {};
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
                    possible_cent(o,p) = im(r(1)-neighb+o, c(1)-neighb+p);
                    pcentloc{o,p} = [r(1)-neighb+o, c(1)-neighb+p];
                end
            end   
            [inten, index] = max(possible_cent(:));
            [row, col] = ind2sub(size(possible_cent),index);
            cent_y = pcentloc{row,col}(1); 
            cent_x = pcentloc{row,col}(2);
            ellipse(neighb/2,neighb/2,0,cent_x,cent_y,'r');
            temp_particles{k} = [cent_x, cent_y, inten];
        end
        all_frames{i,j} = temp_particles{k};
    end
end
%     

%Track the particles in z-slices

%How do we decide if a particle is the same from one z-slice to the
%next? Threshold distance? I think that should work as a first pass. 

dist_thresh = neighb;
fad = struct;
Particles = {};
j = 1;

% for i = 1:size(all_frames,2)-1
%     if ~isempty(all_frames{j,i}) && ~isempty(all_frames{j,i+1})
%         Particles{i} = all_frames{j,i};
%         if abs( sqrt(all_frames{j,i}(2)^2 + all_frames{j,i}(3)^2) - ...
%                 sqrt(all_frames{j,i+1}(2)^2 + all_frames{j,i+1}(3)^2) ) < neighb
%         
%         end
%     end
%     %they are the same particle
%     Particles
end



%%
end