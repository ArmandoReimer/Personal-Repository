function [Accumulator, xdim, ydim] = houghcircle2(Imbinary,r)
% Fast implementation of Circular HOUGH-Transform
% 
% parameters:
% 	Imbinary    ... a binary image (after applying an edge-detection algorithm)
% 	r           ... the radius of circle to detect within the image
% 	Accumulator ... result of the HOUGH-Transform - an image where all circles are accumulated 
% 	                the image is 2*r larger than the input image
% 	xdim, ydim  ... dimensions of the Accumulator image
xdim = size(Imbinary, 2) + ceil(2*r);
ydim = size(Imbinary, 1) + ceil(2*r);
[circle_x, circle_y] = circle(r, r, r);
[edge_y, edge_x] = find(Imbinary);
clear Imbinary;
circlepoints = length(circle_x);
edgepoints = length(edge_x);
points = zeros((circlepoints*edgepoints),1);
pos = 1;
points = (ones(size(edge_x))*round(circle_x) + round(edge_x)*ones(size(circle_x))) * ydim + ...
		 (ones(size(edge_y))*round(circle_y) + round(edge_y)*ones(size(circle_y)));
clear circle_x;
clear circle_y;
clear edge_x;
clear edge_y;
points = reshape(points, 1, (size(points,1) * size(points,2)));
Accumulator = histc(points, (0:1:(max(points(:)))));
clear points;
Accumulator(1) = 0; % delete counts from zeros
if (length(Accumulator) < (xdim*ydim))
	Accumulator = [Accumulator zeros(1, (xdim*ydim)-length(Accumulator))];
end;
Accumulator = reshape(Accumulator(1:(xdim*ydim)), ydim, xdim);
	

function [x,y] = circle(center_x, center_y, radius)
% returns a vector with all circle-corner points containing the correct number of points
numpoints = ceil(2*radius*pi);
theta = linspace(0,2*pi, numpoints);
rho = ones(1,numpoints) * radius;
[x,y] = pol2cart(theta, rho);
x = x+center_x;
y = y+center_y;