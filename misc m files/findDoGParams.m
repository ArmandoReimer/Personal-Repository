im = imread('E:\Armando\LivemRNA\Data\PreProcessedData\2018-08-31-1A3v7L16_mcp_opt_10\2018-08-31-1A3v7L16_mcp_opt_10_128_z10_ch01.tif');
contrasts = [];
% sigma1s = .1:.1:50;
% sigma2s = .1:.1:50;
sigma1s = logspace(-1, 2, 10);
sigma2s = logspace(-1, 2, 10);
filterSizes = 1:2:100;

for sigma1 = 1:length(sigma1s)
    %     sigma1 = 1;
    %     sigma2 = 100;
    %     filterSize = 29
    for sigma2 = 1:length(sigma2s)
        for filterSize = 1:length(filterSizes)
            if sigma1 < sigma2 && filterSize > sigma1 && filterSize > sigma2
                dog = filterImage(im, 'Difference_of_Gaussian', {sigma1s(sigma1),sigma2s(sigma2)},filterSizes(filterSize));
                %             imshow(dog_default, [])
                iSpot = sum(sum(dog(163:180, 105:115)));
                iBack = sum(sum(dog(163+30:180+30, 105+30:115+30)));
                contrast = abs(iSpot - iBack) / abs(iSpot);
                contrasts(sigma1, sigma2, filterSize) = contrast;
            end
        end
    end
end

