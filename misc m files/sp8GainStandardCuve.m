imPath = 'E:\DorsalSynthetics\Data\RawDynamicsData\2020-01-21\FlatField';
rawImages = loadLIFFile(imPath);
rawImages = rawImages(:, 1);

countingIndex = 3; %the third image in the .lif file is not standard mode
countingImage = rawImages{countingIndex}{1};
rawImages(countingIndex) = [];

nImages = length(rawImages);

gain = [10, 20, 40, 60, 90, 100,...
   150, 200, 250, 300, 350, 400, 450, 480, 500];
intensity = zeros(1, nImages);

xDim = size(countingImage, 1);
yDim = size(countingImage, 2);
    ave = @(x) mean(mean(x( xDim/4 : xDim - xDim/4, yDim/4 : yDim - yDim/4)));

    st = @(x) var(x( xDim/4 : xDim - xDim/4, yDim/4 : yDim - yDim/4), 1, 'all');
    
for i = 1:nImages
    %average the intensity in the inner flat field to avoid edge effects
    intensity(i) = ave(double(rawImages{i}{1}));
    intensityNoise = st(double(rawImages{i}{1}));
    
end

countingIntensity = ave(double(countingImage));
countingStd = st(double(countingImage));

figure();
plot(gain, intensity, '-o');
yline(countingIntensity, 'LineWidth', 5);
title('standard curve for sp8 gain')
xlabel('gain (%)')
ylabel('intensity (au)')
% set(gca, 'YScale', 'log');
legend({'standard', 'counting'})
    

figure();
plot(gain, sqrt(intensityNoise)./intensity, '-o');
yline(sqrt(countingStd)./countingIntensity, 'LineWidth', 5);
title('standard curve for sp8 gain')
xlabel('gain (%)')
ylabel('std(intensity) / intensity')
% set(gca, 'YScale', 'log');
legend({'standard', 'counting'})
    
    
    
    
    
