%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Simple implementation (not speed optimized) of AEFA, DEFA and EMAR methods proposed in [1]
%[1] C. Panagiotakis and A. Argyros, Parameter-free Modelling of 2D Shapes with Ellipses, Pattern Recognition, 2015 
%
% You can download the datasets used in [1] from
% https://sites.google.com/site/costaspanagiotakis/research/EFA 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Method Selection
%Set METHOD = 1 to run DEFA method, 
%Set METHOD = 2 to run AEFA method, 
%else you run EMAR method  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

METHOD = 1; 

AICBIC_SELECTION = 1; %Set AICBIC_SELECTION = 1, to use AIC is selected else BIC is used

set(0,'DefaultFigureColormap',jet);

fname = 'im03_9.gif' %filename of test example (input binary image)
[A] = myImRead(sprintf('%s',fname),1);

figure;
imagesc(A);
title('Input Image');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The last two plots show the final result and the AIC/BIC graph for different number of ellipses, respectively.   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if METHOD == 1,
    [IClust,EL,NUMEllipses] = runMergeFitting(A,AICBIC_SELECTION);%DEFA method
elseif METHOD == 2,
    [IClust,EL,NUMEllipses] = runSlitFitting(A,AICBIC_SELECTION);%AEFA method
else
    [IClust,EL,NUMEllipses] = runGMMFitting(A,AICBIC_SELECTION);%EMAR method 
end
   

