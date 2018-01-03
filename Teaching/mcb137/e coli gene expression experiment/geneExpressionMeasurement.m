Mask = imread('mCherry_constitutive.tif');
% imshow(Mask)

%imtool(Mask)

%thresh = 2000

Threshold = 11000;

ImThresh = Mask>Threshold;
% imshow(ImThresh);
% imshowpair(Mask,ImThresh)

ImLabel = bwlabel(ImThresh);
% imshow(ImLabel, []);

imshow(ImLabel==31)
sum(sum(ImLabel==31))

% Areas = [];
% for i = 1:max(max(ImLabel))
%     Areas(i) = sum(sum(ImLabel==i));
% end
% 
% hist(Areas, 50)

MaxArea = 180;
MinArea = 40;

NewMask = zeros(size(ImThresh));

for i = 1:max(max(ImLabel))
    if Areas(i) < MaxArea
        NewMask = NewMask + (ImLabel==i);
    end
%     figure(1)
%     imshow(NewMask)
%     pause(.5)
end

ImFluoRaw = imread('YFP_regulated.tif');
NewMask = NewMask==1;
imshow(ImFluoRaw,[])

ImFluo = immultiply(NewMask, ImFluoRaw);
imshow(ImFluo,[])

ImLabel = bwlabel(ImFluo);

for cell = 1:max(max(ImLabel))
    CurrentCell = ImLabel == cell;
    AreaCell = sum(sum(CurrentCell));
    FluoCell = immultiply(CurrentCell, ImFluoRaw);
    FluoCell = sum(sum(FluoCell));
    YFPexp(cell) = FluoCell/AreaCell;
end

mCherryImages = dir('*mCherry*.tif');
YFPImages = dir('*YFP*.tif');
PhaseImages = dir('*Phase*.tif');

Phase = imread(PhaseImages(1).name);
% imtool(Phase,[]);


Threshold = 165;

ImThresh = Phase < Threshold;
imshowpair(Phase, ImThresh)
ImLabel = bwlabel(ImThresh);
imshow(ImThresh)

Areas = [];
for i = 1:max(max(ImLabel))
    Areas(i) = sum(sum(ImLabel==i));
end

hist(Areas, 10)

MaxArea = 900;
MinArea = 100;

for sample=1:length(YFPImages)
    MaskName = PhaseImages(sample).name;
    
    
    
    

    


