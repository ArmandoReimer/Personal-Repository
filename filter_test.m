load('D:\Data\Armando\livemRNA\Figures\sample_snippet3.mat');
snippet = s3;
[mesh_y,mesh_x] = meshgrid(1:size(snippet,2), 1:size(snippet,1));
close all
pixelSize = 100; %nm
offs = [];
%Look at the effects of your filter on peaks
t = 1:50:500;
for i = 1:length(t)
    figure(1)
    snippet2 = imgaussfilt(snippet, .4);
    imshow(imresize(snippet2,20),[])
    drawnow
    hold on 
    figure(2)
    surf(mesh_y, mesh_x, snippet2);
    title('Raw data');
    set(gcf,'units', 'normalized', 'position',[.01, .1, .33, .33]);
    axis([0 size(snippet,2) 0 size(snippet,1) 10 60])
    drawnow
    m(i) = max(max(snippet2));
 
%Look at the effects of filter on the ability to fit 2D Gaussians
doubleGaussian = @(params) params(1).*exp((-1/2).*(((mesh_x-params(2))./params(3)).^2 ... 
        + ((mesh_y-params(4))./params(3)).^2)) ... 
        + params(5).*exp((-1/2).*(((mesh_x-params(6))./params(7)).^2  ...
        + ((mesh_y-params(8))./params(7)).^2))+ params(9) - double(snippet2);
   
 neighborhood_Size = 1000/pixelSize; %nm
                maxThreshold = 30; %intensity
                widthGuess = t(i) / pixelSize; %nm
                offsetGuess = 30; %intensity
neighborhoodSize = 2*floor(neighborhood_Size/2) + 1;
threshold = 30;   
snippet2 = double(snippet2);
hLocalMax = vision.LocalMaximaFinder;
hLocalMax.NeighborhoodSize = [neighborhoodSize, neighborhoodSize];
hLocalMax.Threshold = threshold;
centers = double(step(hLocalMax, snippet2));                 
initial_parameters = [max(max(snippet2)), centers(1,2), widthGuess, centers(1,1), ...
            0, centers(2,2), widthGuess, centers(2,1), ...
            offsetGuess];    
lsqOptions=optimset('Display','none',... %Inherited these options from Mikhail Tikhonov's FISH analysis
    'maxfunevals',10000,...
    'maxiter',10000);

[double_fit, res1, residual, exitflag, output, lambda, jacobian] = lsqnonlin(doubleGaussian, ...
initial_parameters,zeros(1,9),inf(1,9), lsqOptions);    

gaussian = doubleGaussian(double_fit);
mesh = {mesh_y, mesh_x};
 figure(4)
surf(mesh_y, mesh_x, gaussian + snippet2);
title('Double Gaussian fits')
set(gcf,'units', 'normalized', 'position',[0.01, .55, .33, .33]);
drawnow
offs(i) = double_fit(end);
widths(i) = double_fit(3);
chisq(i) = sum(sum(residual.^2));
end
% 
% figure(5)
% plot(t, m/max(m))
% xlabel('Radius of Gaussian kernel')
% ylabel('Amplitude (normalized by maximum)')

figure(5)
plot(t, offs)
figure(6)
plot(t, widths)
figure(7)
plot(t, chisq)
title('Chi-squared')