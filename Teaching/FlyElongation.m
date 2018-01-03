
%Load frame 113
Image=imread('5Loops113.tif');
imshow(Image)

%We get a black square. Why?
whos Image      %Get information about the data stored in a variable

%Note that our image is a 16-bit image with 2^16 levels of gray. However,
%Matlab (and your screen) can only display 256 levels of gray. We need to
%tell Matlab how to map the different levels. An approach could be to grab
%the dimmest pixel, set it to 0, and grab the brightest pixel, and set it
%to 1.
imshow(Image,[])

%Find a threshold by inspecting the pixel values using imtool
%imtool(Image,[])
Threshold=1000;

%Take the threshold
ImThresh=Image>Threshold;
imshow(ImThresh)

%Label the connected regions in the image
ImLabel=bwlabel(ImThresh);
imshow(ImLabel,[])
%imtool(ImLabel,[])

%To find the number of spots, we find the maximum value corresponding to
%regions in the labeled image
NSpots=max(max(ImLabel))


%Analyze the 5' movie
%Get the images in the folder
D5=dir('5Loops*.tif');

%Segment each image and count spots
for i=1:length(D5)
    %Load the image
    Image=imread(D5(i).name);
    %Take the threshold
    ImThresh=Image>Threshold;
    %Find spots
    ImLabel=bwlabel(ImThresh);
    %Count spots
    NSpots5(i)=max(max(ImLabel));
end
Time5=(1:length(D5))*10;        %In seconds
plot(Time5,NSpots5,'-r')
xlabel('Time (s)')
ylabel('Nspots')

%Analyze the 3' movie
%Get the images in the folder
D3=dir('3Loops*.tif');

%Segment each image and count spots
for i=1:length(D3)
    %Load the image
    Image=imread(D3(i).name);
    %Take the threshold
    ImThresh=Image>Threshold;
    %Find spots
    ImLabel=bwlabel(ImThresh);
    %Count spots
    NSpots3(i)=max(max(ImLabel));
end
Time3=(1:length(D3))*10;        %In seconds

hold on
plot(Time3,NSpots3,'-b')
hold off
legend('5','3')
    





















