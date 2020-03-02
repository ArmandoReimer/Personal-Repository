yDim = size(im, 1); xDim = size(im, 2);
pixelSize = .1;
min_area = pi*(2/pixelSize)^2; max_area = pi*(5/pixelSize)^2;
stats= regionprops(~logical(d.cleanedFibSkel),'all');
eccs = [stats.Eccentricity]; % figure(1); histogram(circs, 20)
circs = [stats.Circularity];

blankIm = zeros(yDim, xDim);
maskTotal = blankIm; %for diagnostics
for r = 1:numel(stats)
    hull_points = stats(r).ConvexHull;
    mask = poly2mask(hull_points(:,1),hull_points(:,2),yDim,xDim);  
   mask = bwareafilt(mask, [min_area, max_area]); %throw out small oversegmentation products
  
%     mask = bwpropfilt(mask,'Eccentricity', [0 .9] );
    circs= regionprops(logical(mask),'Circularity');
    circs = [circs.Circularity];
    if circs < .9
%         mask =  blankIm;
    end
    
    maskTotal = maskTotal + mask;
end
d.imHullMask = maskTotal;


%%
if displayFigures
    ims = fieldnames(d);
    imageCell = {};
    for i = 1:length(ims)
        imageCell{i} = d.(ims{i});
    end
    imageTile(imageCell, ims);
end

[B,L] = bwboundaries(d.cleanedFibSkel);
figure(1); 
% imagesc(d.cleanedFibSkel);
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', .5)
end
