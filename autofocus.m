close all;
%here i read in the data--------------------------------------------------
t2 = tcpip('128.32.173.234')
fopen(t2)
command = '/cli:Leica-SP8PR-WS /app:matrix /cmd:startscan';
fwrite(t2, command);

loc = 'D:\MatrixScreenerImages';
imdir = [loc, 'D:\MatrixScreenerImages\3.3.0_9757\a--15_11_2016_07_45\b--S00\c--U00--V00\d--X00--Y00\AF']
mdir = [imdir, 'metadata\image--L0000--S00--U00--V00--J19--E00--O00--X01--Y01--T0000.ome.xml'];
cin = fileread(c)
cdir = [imdir, 'image--L0000--S00--U00--V00--J19--E00--O00--X01--Y01--T0000--Z00--C00.ome.tif']
imshow(cdir);
    

t2 = tcpip('128.32.173.234')
fopen(t2)


%sample_image = 'D:\Data\Armando\livemRNA\Data\PreProcessedData\2016-10-18-1A3+5-evePr_7_Mikhail\2016-10-18-1A3+5-evePr_7_Mikhail-His_056.tif';
d = 'D:\Data\Armando\livemRNA\Data\PreProcessedData\2016-10-18-1A3+5-evePr_7_Mikhail\';
sample_stack_dir = dir(d);
dirlength = length(sample_stack_dir);

%here i do the algorithm-------------------------------------------------
n_spotss = [];
for i = 1:dirlength
    if ~isempty(strfind(sample_stack_dir(i).name, 'His'))
        im = imread([d, sample_stack_dir(i).name]);
        %imshow(im, [])
        im2 = double(im>16);
        %imshow(im2,[]);
        filterSize = 20 %size of square to be convolved with microscopy images
        dog = conv2(single(im2), single(fspecial('gaussian',filterSize, 1.5) - fspecial('gaussian',filterSize, 5)),'same');
        %dog = padarray(dog(filterSize:end-filterSize-1, filterSize:end-filterSize-1), [filterSize,filterSize]);
        dog = double(dog> .1);
        dog = imgaussfilt(dog,3);
        imshow(dog,[]);
        [im_label, n_spots] = bwlabel(im2bw(dog));
        n_spotss(i) = n_spots
    end
end
[max, max_index] = max(n_spotss);

%this is the string in the xml metadata for objective position
%<OriginalMetadata ID="OriginalMetadata:295" Name="Data - Image -
%Attachment - ATLConfocalSettingDefinition - AdditionalZPositionList - AdditionalZPosition - ZPosition" Value="0.004369592575"/> 

%and this is the string in the metadata for galvo
%<StagePosition PositionX="0.6361308266446E-1"
%PositionY="0.3963815353338E-1" PositionZ="-0.397897146E-5"/>

zpos = 100; %extract this position from metadata
%here go the commands to leica-------------------------------------------------

t2 = tcpip('128.32.173.234')
fopen(t2)
command = ['/cli:Leica /app:matrix /sys:0 /cmd:setposition /typ:absolute',...
            '/dev:zdrive /unit:microns /zpos:', num2str(zpos)];
fwrite(t2, command);
fclose(t2);