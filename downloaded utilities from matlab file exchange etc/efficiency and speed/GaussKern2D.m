function ZG = GaussKern2D(width,height,s)

%2-D Gaussian Kernel Generator
% Given:
%
% w, half window width (positive integer)
% h, half window height (positive integer)
% and s, covariance matrix (2x2 non-singular matrix),
%
% compute: ZG, (2*h+1 x 2*w+1 matrix) the discretized probability density
% of the specified Gaussian function with average at the central cell.

% Code is optimized to run HELLA FAST

dets = s(1)*s(4)-s(2)*s(3);
sinv = 1/dets*[s(4) -s(2); -s(3) s(1)];
pref = 1 / (2*pi*dets^0.5);
[X, Y] = meshgrid((-width:width),(-height:height));

S1 = ones(size(X)).*sinv(1,1);
S2 = ones(size(X)).*sinv(1,2);
S3 = ones(size(X)).*sinv(2,1);
S4 = ones(size(X)).*sinv(2,2);

ZG = zeros(size(X));
ZG = pref.*exp(-0.5.*(X.*(S1.*X + S2.*Y) + Y.*(S3.*X + S4.*Y)));

% Uncomment to see a heat map of your kernel
figure
pcolor(ZG)
axis equal

end