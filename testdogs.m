im = imread('C:\Users\ArmandoReimer\Desktop\2015-07-25-test_P2P_75uW_bi_test.jpg');
pixelSize = 212;
figure(1)
imshow(im, [])
sigma1 = pixelSize / pixelSize; %width of narrower Gaussian
sigma2 = 3000 / pixelSize; % width of wider Gaussian
filterSize = round(3000 / pixelSize); %size of square to be convolved with microscopy images
dog = conv2(single(im), single(fspecial('gaussian',filterSize, sigma1) - fspecial('gaussian',filterSize, sigma2)),'same');
dog = padarray(dog(filterSize:end-filterSize-1, filterSize:end-filterSize-1), [filterSize,filterSize]);
figure(2)
dog2 = dog.*(dog>18);
imshow(dog2, [])