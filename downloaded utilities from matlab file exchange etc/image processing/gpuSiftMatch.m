function m = gpuSiftMatch(d1,d2,thresh,bunchSize,gpuEn,precision)
%% gpuSiftMatch performs SIFT matching on GPU
% Inputs:
%           d1 - descriptor set from image 1
%           d2 - descriptor set from image 2
% Optional inputs (pass empty to use defaults):
%           thresh - David Lowe's nearest neighbor threshold
%           bunchSize - number of distances calculated per bunch
%           gpuEn - enable GPU flag (mist be true or false, i.e. logical)
%           precision - 'single' or 'double' (single should be faster)
%           
% Outputs:
%           m - matrix of matches between descriptors d1 and d2 such that:
%           d1(m(1,:)) corresponds to d2(m(2,:))
%
% Ben Thomas, University of Bath, July 2017

%% Set defaults
if ~(exist('thresh','var') && ~isempty(thresh))
    thresh = 0.6;   % Lowe suggests 0.4
end

if ~(exist('bunchSize','var') && ~isempty(thresh))
    bunchSize = 256; % Tweak as neccesary - larger is faster
end

if ~(exist('gpuEn','var') && ~isempty(thresh))
    nGpus = gpuDeviceCount();
    if nGpus > 0
        gpuEn = true;
    else
        gpuEn = false;
    end
end

if ~(exist('precision','var') && ~isempty(thresh))
    precision = 'single';
end

d1 = gpuArr(d1,gpuEn,precision);
d2 = gpuArr(d2,gpuEn,precision);

[featDist, I] = getDistances(d1,d2,bunchSize);

m = zerosGpu(size(I),gpuEn);
m(1,:)=I(1,:);
m(2,:)=1:size(I,2);

mLogical = featDist(1,:)./featDist(2,:)<thresh;

m = gather(m(:,mLogical));

end

function [distanceOut,IOut] = getDistances(d1,d2,bunchSize)

    bunchVec = unique([0:bunchSize:size(d2) size(d2)]);
    nBunches = length(bunchVec);
    featDist = cell(1,length(bunchVec));
    I = cell(1,length(bunchVec));
%     minProg = [];
    
    for iBunch = 1:nBunches-1
%         minProg = mWaitbar('Finding matching features...',iBunch,nBunches-1,minProg);
        [dSub,Isub] = pdist2(d1,d2(bunchVec(iBunch)+1:bunchVec(iBunch+1),:),'euclidean','Smallest',2);
        featDist{iBunch} = double(gather(dSub));
        I{iBunch} = gather(Isub);
    end
%     mWaitbar('Finding matching features...','close');
    distanceOut = cell2mat(gather(featDist));
    IOut = cell2mat(I);

end

function var = gpuArr(var, en, prec)
%% Place variable into gpu memory
% Inputs:
%           var - variable to be moved
%           en - bimary switch if it should be moved (1 or zero)
% Optional input:
%           prec - precision of variable in gpu memory
% Ouputs:
%           var - gpu variable
%
% Ben Thomas, University of Bath, Feb 2017

% Change precision if desired
if ~exist('prec','var')
%     prec = 'double';
elseif strcmp(prec,'single') 
    var = single(var);
end

% Convert to gpuArray
if en
    var = gpuArray(var);
end

end

function out = zerosGpu(varargin)
%% Create array of zeros directly on GPU
% Inputs:
%           s1, s2, s3 etc - size of each dimension
%           gpuEn - gpu enable switch. Must be a logical (true/false)
% Optional inputs:
%           precision - either 'single' or 'double'
% Outpus:
%           out - array of zeros stored on GPU
%
% Ben Thomas, University of Bath, 2016
%
% Get inputs from varargin (we don't know ahead of time how many size
% inputs will be input)

sizes = [];
for i=1:length(varargin)
    if isnumeric(varargin{i})   % Must be a size, either in vector or scalar format
        sizes = [sizes varargin{i}];
    elseif islogical(varargin{i})
        gpuEn = varargin{i};
    elseif ischar(varargin{i})
        precision = varargin{i};
    end
end

if ~exist('gpuEn','var')
    error('gpuEn must be a logical')
end

if ~exist('precision','var')
    precision = 'double';
end

% Generate array
if gpuEn
    out = zeros(sizes,precision,'gpuArray');
else
    out = zeros(sizes,precision);
end

end
