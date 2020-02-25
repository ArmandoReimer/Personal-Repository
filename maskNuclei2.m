function [centers, radii, nuclearMask] = maskNuclei2(im)

% radiiRange = [40, 80];
% scaleRange = radiiRange(1):round(radiiRange(2));
% scaleRange = 10:15;
% n = 0;
% for scale = scaleRange
%     n = n + 1;

%the meat of the operation- the canny filter
scale = 12;
im2 = canny(rescale(im), scale);

%the rest is just cleaning up the edges and filtering out non-toroidal objects
im2 = fibermetric(double(im2));
im2 = bwmorph(im2, 'skel');
for k = 1:20
    im2 = bwmorph(im2, 'shrink');
    im2 = bwmorph(im2, 'clean');
    im2 = bwmorph(im2, 'bridge');
    im2 = bwmorph(im2, 'diag');
    im2 = bwmorph(im2, 'shrink');
    im2 = bwmorph(im2, 'clean');
end


a = im2;
se = strel('disk', 2);
nCircles = [];
nCircles = [nCircles, length(regionprops(logical(a)))];
chg = 0;
tol = 2; %process stays constant for 5 steps
while chg < tol
    a = imdilate(a, se);
    a = bwmorph(a, 'fill');
    a = bwpropfilt(a,'EulerNumber',[0, 0]);
    nCircles = [nCircles, length(regionprops(logical(a)))];
    
    if nCircles(end) == nCircles(end-1)
        chg = chg + 1;
    else
        chg = 0;
    end
    if chg == tol
        break;
    end
    
end

im2 = im2.*a;
im2 = fibermetric(double(im2));
im2 = bwmorph(im2, 'bridge');
im2 = bwmorph(im2, 'diag');


for k = 1:100
    im2 = bwmorph(im2, 'skel');
    im2 = bwmorph(im2, 'spur');
end

% figure(1); imshow(im2, [])

%     a = imfill(im2, 'holes');
%     figure(4); imshow(a, [])
cs= regionprops(logical(a), 'Centroid');
radii = regionprops(logical(a), 'EquivDiameter');
radii = [radii.EquivDiameter]/2;
centers=[];
for k = 1:length(cs)
    centers(k, :) = cs(k).Centroid;
end

nuclearMask = filledVisCircles(im2, centers, radii);

% viscircles(centers, radii)
% figure(2); imshow(im, []); viscircles(centers, radii);

end

% end