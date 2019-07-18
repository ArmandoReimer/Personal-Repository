function [h, ax] = segmentationFreeMS2Analysis(Prefix, nBins, varargin)

%color is the bin color accepted as a string within one element cell.
%use an empty cell as default. accepted colors- 'red', 'yellow', 'cyan', 'magenta',
%'lightBlue'

scale = 1;
color = {'red'}; %just using red as the default
optionalResults = '';
ax = [];

%area for improvement: segment the nuclei and only include dog values from
%within nuclei 
for i = 1:length(varargin)
    if strcmpi(varargin{i}, 'color')
        color = varargin{i+1};
    elseif strcmpi(varargin{i}, 'scale')
        scale = varargin{i+1};
    elseif strcmpi(varargin{i}, 'ax')
        ax = varargin{i+1};
    end
end

if isempty(ax)
    fig = figure();
    ax = axes(figure);
end

[~,ProcPath,DropboxFolder] = readMovieDatabase(Prefix, optionalResults);


dogDirPath = [ProcPath,filesep,Prefix,'_\dogs'];
dogDir = dir([dogDirPath, filesep,'DOG*.mat']);
dogDir= {dogDir.name};
numIm = length(dogDir);

if contains(dogDir{1}, 'mat')
    saveType = 'mat';
elseif contains(dogDir{1}, 'tif')
    saveType = 'tif';
end

vals = [];

try
    parpool(20);
end

parfor i = 1:numIm
    
    if strcmpi(saveType, 'tif')
        dog = imread([dogDirPath, filesep, dogDir{i}]);
    elseif strcmpi(saveType, 'mat')
        dog = load([dogDirPath, filesep, dogDir{i}]);
        dog = dog.plane;
    end
    
    vals(i) = log10(max(dog(:))+1);
    
    %imshow(dog, []);
    
end

vals(vals==0) = NaN;
h = histogram(ax, vals,nBins,'Normalization','pdf', 'facealpha', .6);
set(ax,'YScale','log');
xlabel(ax, 'log(max DoG intensity + 1) (au)');
ylabel(ax, 'frequency');
title(Prefix, 'Interpreter', 'none');
standardizeFigure(ax, [], color{1}, 'fontSize', 14);
hold on


end