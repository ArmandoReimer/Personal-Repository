function extractSnippetsFor2ColorElongation(Prefix3, Prefix5)

% extractSnippetsFor2ColorElongation
%
% DESCRIPTION
% Isolate spots from different channels in 2 color experiments to compare
% green and red time traces.
%
% ARGUMENTS
% Prefixes for the elongation data (one prefix per channel)
%
% OPTIONS
% None.
%               
% OUTPUT
% Plots.
%
% Author (contact): Armando Reimer (areimer@berkeley.edu)
% Created: 6/27/17
% Last Updated: 8/31/2017
%
% Documented by: Armando Reimer (areimer@berkeley.edu)

%Data for elongation experiment

[SourcePath,FISHPath,DefaultDropboxFolder,MS2CodePath,PreProcPath]=...
    DetermineLocalFolders;


path5 = [DefaultDropboxFolder, filesep,Prefix5, filesep];
path3 = [DefaultDropboxFolder, filesep,Prefix3, filesep];
%mcp5spots = load('D:\Data\Armando\livemRNA\Data\Dropbox\DynamicsResults\2017-04-24-P2P_MS2_LacZ_PP7c2\Spots.mat');
mcp5spots = load([path5, 'Spots.mat']);
mcp5spots = mcp5spots.Spots;
%mcp5frameinfo = load('D:\Data\Armando\livemRNA\Data\Dropbox\DynamicsResults\2017-04-24-P2P_MS2_LacZ_PP7c2\FrameInfo.mat');
mcp5frameinfo = load([path5, 'FrameInfo.mat']);
mcp5frameinfo = mcp5frameinfo.FrameInfo;
%mcp5particles = load('D:\Data\Armando\livemRNA\Data\Dropbox\DynamicsResults\2017-04-24-P2P_MS2_LacZ_PP7c2\Particles.mat');
mcp5particles = load([path5, 'Particles.mat']);
mcp5particles = mcp5particles.Particles;
pcp3spots = load([path3, 'Spots.mat']);
pcp3spots = pcp3spots.Spots;
pcp3particles = load([path3, 'Particles.mat']);
pcp3particles = pcp3particles.Particles;

%%%%%%%

%%%%Data for calibration
% mcp5spots = load('D:\Data\Armando\livemRNA\Data\Dropbox\DynamicsResults\2017-04-25-P2P_MS2-PP7-LacZ_20secc2\Spots.mat');
% mcp5spots = mcp5spots.Spots;
% mcp5frameinfo = load('D:\Data\Armando\livemRNA\Data\Dropbox\DynamicsResults\2017-04-25-P2P_MS2-PP7-LacZ_20secc2\FrameInfo.mat');
% mcp5frameinfo = mcp5frameinfo.FrameInfo;
% mcp5particles = load('D:\Data\Armando\livemRNA\Data\Dropbox\DynamicsResults\2017-04-25-P2P_MS2-PP7-LacZ_20secc2\Particles.mat');
% mcp5particles = mcp5particles.Particles;
% pcp3spots = load('D:\Data\Armando\livemRNA\Data\Dropbox\DynamicsResults\2017-04-25-P2P_MS2-PP7-LacZ_20secc1\Spots.mat');
% pcp3spots = pcp3spots.Spots;
% pcp3particles = load('D:\Data\Armando\livemRNA\Data\Dropbox\DynamicsResults\2017-04-25-P2P_MS2-PP7-LacZ_20secc1\Particles.mat');
% pcp3particles = pcp3particles.Particles;
% 

%%%%%%%

[SourcePath5,FISHPath5,DropboxFolder5,MS2CodePath5,PreProcPath5]=...
    DetermineLocalFolders(Prefix5);
[SourcePath3,FISHPath3,DropboxFolder3,MS2CodePath3,PreProcPath3]=...
    DetermineLocalFolders(Prefix3);

%iterate over the particles and create a structure that has the snippets for
%each time point. somehow we need to identify each red particle with each
%green particle. can try based on position but may need to go back and try
%a legit 2color, 2channel experiment in the pipeline.

s5 = struct;
s3 = struct;

%Create the 5' analysis structure
p = mcp5particles;
sp = mcp5spots;
st = struct;
for i = 1:length(p)
    %initialize the final structure for analysis
    trace_length = length([p(i).Frame]);
    st(i).Frame = zeros(1, trace_length);
    st(i).Snippet = cell(1, trace_length);
    st(i).Position = cell(1, trace_length);
    st(i).Snippet3 = cell(1, trace_length);

    
    %add in particle frame information
    st(i).Frame = [p(i).Frame];
    
    %add in particle snippets (will do a max projection, so one snippet per
    %particle per frame) and spot positions (at the brightest z-plane)
    for t = 1:trace_length
        try
            index = p(i).Index(t);
            f = p(i).Frame(t);
            if ~isempty(sp(f).Fits)
                fits = sp(f).Fits(index);
                x = fits.xDoG(fits.z == fits.brightestZ);
                y = fits.yDoG(fits.z == fits.brightestZ);
                Snippets3 = fits.Snippet;
                s = size(Snippets3{1});
                snippet3 = zeros(s);
                for l = 1:s
                    for m = 1:s
                        vals3 = [];
                        for k = 1:length(Snippets3)
                            vals3(k) = Snippets3{k}(l,m);
                        end
                        snippet3(l, m) = max(vals3);
                    end
                end

                st(i).Snippet{t} = snippet3;
                st(i).Position{t} = [x,y];
    %             r = (size(snippet3, 1) - 1)/2;
                r = 10;
                try
                im3 = double(imread([PreProcPath3,filesep,Prefix3,filesep,Prefix3,'_',iIndex(f,3),'_z',iIndex(fits.brightestZ,2),'.tif']));      
                snip3 = im3(y-r:y+r, x-r:x+r);
                st(i).Snippet3{t} = snip3;           
                catch
                end
            else
                st(i).Snippet{t} = [];
                st(i).Position{t} = [];
                st(i).Snippet3{t} = [];
            end
        catch
        end
    end
end
s5 = st;


%Same for 3'
p = pcp3particles;
sp = pcp3spots;
st = struct;
zmax = mcp5frameinfo(1).NumberSlices;
for i = 1:length(p)
    %initialize the final structure for analysis
    trace_length = length([p(i).Frame]);
    st(i).Frame = zeros(1, trace_length);
    st(i).Snippet = cell(1, trace_length);
    st(i).Snippet5 = cell(1, trace_length);
    st(i).brightestZ = cell(1, trace_length);
    
    %add in particle frame information
    st(i).Frame = [p(i).Frame];
    %add in particle snippets (will do a max projection, so one snippet per
    %particle per frame) and spot positions (at the brightest z-plane)
    for t = 1:trace_length
        try
        index = p(i).Index(t);
        f = p(i).Frame(t);
        if ~isempty(sp(f).Fits)
            fits = sp(f).Fits(index);
            x = fits.xDoG(fits.z == fits.brightestZ);
            y = fits.yDoG(fits.z == fits.brightestZ);
            st(i).brightestZ{t} = fits.brightestZ;
%             Snippets = fits.Snippet; %I want to replace this line with the
            %snippets i really want
            s = size(fits.Snippet{1}, 1);
            s = (s*2)+1;
            dz = 2;
            r = (s - 1)/2;
% r = 5;
            Snippets3 = {};
            Snippets5 = {};
            while dz + fits.brightestZ > zmax|| fits.brightestZ - dz < 1
                dz = dz - 1;
            end
            for a = -dz:dz
                z = fits.brightestZ + a;
                im3 = double(imread([PreProcPath3,filesep,Prefix3,filesep,Prefix3,'_',iIndex(f,3),'_z',iIndex(z,2),'.tif']));                 
                mask3 = im3;
                mask3 = zeros(size(im3, 1), size(im3, 2));
                mask3(y-r:y+r,x-r:x+r) = im3(y-r:y+r,x-r:x+r);    
                Snippets3{a+dz+1} = im3(y-r:y+r,x-r:x+r);
                im5 = double(imread([PreProcPath5,filesep,Prefix5,filesep,Prefix5,'_',iIndex(f,3),'_z',iIndex(z,2),'.tif']));                 
                mask5 = im5;
                mask5 = zeros(size(im5, 1), size(im5, 2));
                mask5(y-r:y+r,x-r:x+r) = im5(y-r:y+r,x-r:x+r);  
                Snippets5{a+dz+1} = im5(y-r:y+r,x-r:x+r);    
            end

            snippet3 = zeros(s);
            snippet5 = zeros(s);
            for l = 1:s
                for m = 1:s
                    vals3 = [];
                    for k = 1:length(Snippets3)
                        vals3(k) = Snippets3{k}(l,m);
                        vals5(k) = Snippets5{k}(l,m);
                    end
                    if ~isempty(vals3)
                        snippet3(l, m) = max(vals3);
                    end
                    if ~isempty(vals5)
                        snippet5(l,m) = max(vals5);
                    end
                end
            end
            st(i).Snippet{t} = snippet3;
            st(i).Position{t} = [x,y];
            st(i).mask3{t} = mask3;
            st(i).mask5{t} = mask5;
%             im5 = double(imread([PreProcPath5,filesep,Prefix5,filesep,Prefix5,'_',iIndex(f,3),'_z',iIndex(fits.brightestZ,2),'.tif']));      
%             snip5 = im5(y-r:y+r,x-r:x+r);
            st(i).Snippet5{t} = snippet5;  
        else
            st(i).Snippet{t} = [];
            st(i).Position{t} = [];
            st(i).Snippet5{t} = [];
        end
        catch
    end
    end
end
s3 = st;
% 
% %Now we need to map a green particle to a red particle.
% dthresh = 10; %if the particles are within 10 pixel of eachother, they're the same?
% for i = 1:length(s5)
%     d = [];
%     for j = 1:length(s3)
%         xm5 = 0;
%         xm3 = 0;
%         ym5 = 0;
%         ym3 = 0;
%         for k = 1:length(s5(i).Position)
%             xm5 = xm5 + s5(i).Position{k}(1);
%             ym5 = ym5 + s5(i).Position{k}(2);
%         end
%         xm5 = xm5 / length(s5(i).Position);
%         ym5 = ym5 / length(s5(i).Position);
%         for k = 1:length(s3(j).Position)
%             xm3 = xm3 + s3(j).Position{k}(1);
%             ym3 = ym3 + s3(j).Position{k}(2);
%         end
%         xm3 = xm3 / length(s3(j).Position);
%         ym3 = ym3 / length(s3(j).Position);
%         d = [d, sqrt( (xm5 - xm3).^2 + (ym5 - ym3).^2 )];
%     end
%     [dmin, index] = min(d);
%     if dmin <= dthresh
%         s5(i).Index3 = index; %they're the same particle. 
%     else 
%         s5(i).Index3 = 0;
%     end
% end
% %Same for 3
% for j = 1:length(s3)
%     d = [];
%     for i = 1:length(s5)
%         xm5 = 0;
%         xm3 = 0;
%         ym5 = 0;
%         ym3 = 0;
%         for k = 1:length(s5(i).Position)
%             xm5 = xm5 + s5(i).Position{k}(1);
%             ym5 = ym5 + s5(i).Position{k}(2);
%         end
%         xm5 = xm5 / length(s5(i).Position);
%         ym5 = ym5 / length(s5(i).Position);
%         for k = 1:length(s3(j).Position)
%             xm3 = xm3 + s3(j).Position{k}(1);
%             ym3 = ym3 + s3(j).Position{k}(2);
%         end
%         xm3 = xm3 / length(s3(j).Position);
%         ym3 = ym3 / length(s3(j).Position);
%         d = [d, sqrt( (xm5 - xm3).^2 + (ym5 - ym3).^2 )];
%     end
%     [dmin, index] = min(d);
%     if dmin <= dthresh
%         s3(j).Index5 = index; %they're the same particle. 
%         s3(j).Frames5 = s5(index).Frame;
%         s3(j).Snippets5 = s5(index).Snippet;
%     else 
%         s3(j).Index5 = 0;
%     end
% end

n = 10; %this is the duration in frames that I look backwards in time in the red channel at the location of the green spot
%this means the first prefix should be green, usually
for i = 1:length(s3)
    try
        if s3(i).Frame(1)>n
            snips = {};
            s = s3(i);
            x = s.Position{1}(1);
            y = s.Position{1}(2);
            z1 = s.brightestZ{1};
            snipsize = size(fits.Snippet{1}, 1);
            snipsize = (snipsize*2)+1;
            dz = 2;
            r = (snipsize - 1)/2; %changed
    %         r = 10;

            for t = 1:n
                f = s.Frame(1) - (n+1-t); %go back in time
                %%%%%         
                Snippets3 = {};
                Snippets5 = {};
                while dz + z1 > zmax|| z1 - dz < 1
                    dz = dz - 1;
                end
                for a = -dz:dz
                    z = fits.brightestZ + a;                
                    im3 = double(imread([PreProcPath3,filesep,Prefix3,filesep,Prefix3,'_',iIndex(f,3),'_z',iIndex(z,2),'.tif']));                 
                    mask3 = im3;
                    mask3 = zeros(size(im3, 1), size(im3, 2));
                    mask3(y-r:y+r,x-r:x+r) = im3(y-r:y+r,x-r:x+r);               
                    Snippets3{a+dz+1} = im3(y-r:y+r,x-r:x+r);
                    im5 = double(imread([PreProcPath5,filesep,Prefix5,filesep,Prefix5,'_',iIndex(f,3),'_z',iIndex(z,2),'.tif']));                 
                    Snippets5{a+dz+1} = im5(y-r:y+r,x-r:x+r);
                    mask5 = im5;
                    mask5 = zeros(size(im5, 1), size(im5, 2));
                    mask5(y-r:y+r,x-r:x+r) = im5(y-r:y+r,x-r:x+r);  
                end
                snippet3 = zeros(snipsize);
                snippet5 = zeros(snipsize);
                for l = 1:snipsize
                    for m = 1:snipsize
                        vals3 = [];
                        for k = 1:length(Snippets3)
                            vals3(k) = Snippets3{k}(l,m);
                            vals5(k) = Snippets5{k}(l,m);
                        end
                        if ~isempty(vals3)
                            snippet3(l, m) = max(vals3);
                        end
                        if ~isempty(vals5)
                            snippet5(l,m) = max(vals5);
                        end
                    end               
                end

                %%%%%
    %             im3 = double(imread([PreProcPath3,filesep,Prefix3,filesep,Prefix3,'_',iIndex(f,3),'_z',iIndex(z, 2),'.tif']));              
    %             snip3 = im3(y-r:y+r,x-r:x+r);
                snips{t} = snippet3;
                snipsmask3{t} = mask3;
    %             im5 = double(imread([PreProcPath5,filesep,Prefix5,filesep,Prefix5,'_',iIndex(f,3),'_z',iIndex(z, 2),'.tif']));              
    %             snip5 = im5(y-r:y+r,x-r:x+r);
                snips5{t} = snippet5;     
                snipsmask5{t} = mask5;
            end
                s3(i).SnippetRed = [snips5, s.Snippet5];
                s3(i).SnippetGreen = [snips, s.Snippet];
                s3(i).maskred = [snipsmask5, s.mask5];
                s3(i).maskgreen = [snipsmask3, s.mask3];
                fs = s.Frame(1)-10:1:s.Frame(1)-1;
                s3(i).newFrames = [fs, s.Frame];
        end
    catch
    end
end




% 
% %Not sure if I'll need this structure
% sboth = struct;
% for i = 1:length(mcp5particles)
%     for j =length(pcp5particles)
%         sboth = [];
%     end
% end
% 
% %new tack. take images from 5 and 3 from the time t starts to the time 3
% %ends
% 
% for i = 1:length(s5)
%     frames = [s5(i).Frame];
%     for t = 1:length(frames)
%         pos = s3(i).Position(t);
%         
%     end
% end

save([DefaultDropboxFolder,filesep,Prefix3,filesep,'extract3.mat'], 's3');
save([DefaultDropboxFolder,filesep,Prefix5,filesep,'extract5.mat'], 's5');
% 
% 
end



