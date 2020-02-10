imPath = 'E:\DorsalSynthetics\Data\RawDynamicsData\2020-01-24\ZeissDataSets\FlatFieldZeissTest\venus';
D = dir([imPath,filesep, '*.lsm']);
nImages = length(D);
for i = 1:nImages
    LSMImages = bfopen([imPath, filesep, D(i).name]);
    rawImages{i} = LSMImages{1}{1};
end

% 
% countingIndex = 3; %the third image in the .lif file is not standard mode
% countingImage = rawImages{countingIndex}{1};
% rawImages(countingIndex) = [];

nImages = length(rawImages);

%for venus
gain = [500, 550, 600, 650, 700, 763, 770, 780, 790, 800, 850, 900];
%for mcherry
% gain = [];

intensity = zeros(1, nImages);

xDim = size(rawImages{1}, 1);
yDim = size(rawImages{1}, 2);
    ave = @(x) mean(mean(x( xDim/4 : xDim - xDim/4, yDim/4 : yDim - yDim/4)));

    st = @(x) var(x( xDim/4 : xDim - xDim/4, yDim/4 : yDim - yDim/4), 1, 'all');
    
for i = 1:nImages
    %average the intensity in the inner flat field to avoid edge effects
    intensity(i) = ave(double(rawImages{i}));
    intensityNoise = st(double(rawImages{i}));
    
end

% countingIntensity = ave(double(countingImage));
% countingStd = st(double(countingImage));

figure();
plot(gain, intensity, '-o');
% yline(countingIntensity, 'LineWidth', 5);
title('standard curve for zeiss gain venus channel')
xlabel('gain (%)')
ylabel('intensity (au)')
% set(gca, 'YScale', 'log');
legend({'standard', 'counting'})
    

figure();
plot(gain, sqrt(intensityNoise)./intensity, '-o');
% yline(sqrt(countingStd)./countingIntensity, 'LineWidth', 5);
title('standard curve for zeiss gain venus channel')
xlabel('gain (%)')
ylabel('std(intensity) / intensity')
% set(gca, 'YScale', 'log');
legend({'standard', 'counting'})
    
    
    
    
    
