close all;
%here i read in the data--------------------------------------------------

loc = 'D:\MatrixScreenerImages';
c = [loc, '3.30_9757\experiment--2016_11_07_22_06_06\slide--S00\chamber-U00-V00\field--X01-Y01\metadata';
    
    

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
zpos = 100; %extract this position from metadata
%here go the commands to leica-------------------------------------------------

command = ['/cli:Leica /app:matrix /sys:0 /cmd:setposition /typ:absolute',...
            '/dev:zdrive /unit:microns /zpos:', num2str(zpos)];
fwrite(t2, command);
fclose(t2);