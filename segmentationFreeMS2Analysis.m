function h = segmentationFreeMS2Analysis(Prefix, nBins, varargin)
    
%color is the bin color accepted as a string within one element cell.
%use an empty cell as default. accepted colors- 'red', 'yellow', 'cyan', 'magenta',
%'lightBlue'
    
    scale = 1;
    color = {'red'}; %just using red as the default
    
    for i = 1:length(varargin)
       if strcmpi(varargin{i}, 'color')
           color = varargin{i+1}; 
       elseif strcmpi(varargin{i}, 'scale')
           scale = varargin{i+1};
       end
    end
    
    dogDirPath = ['E:\SyntheticEnhancers\Data\ProcessedData\',Prefix,'_\dogs'];
    dogDir = dir([dogDirPath, filesep,'DOG*.tif']);
    numIm = length(dogDir); 
    vals = [];
    for i = 3:numIm
        dog = imread([dogDirPath, filesep, dogDir(i).name]);
        %10k is the offset in most datasets. some might have offset 1000.
        %this is subtracted for aesthetics. 
        dog = dog - 10000;
        vals(i) = log10(double(scale*max(dog(:))) + 1);
%         vals(i) = double(scale*max(dog(:)));

        %imshow(dog, []);
    end
    vals(vals==0) = NaN;
    h = histogram(vals,nBins,'Normalization','probability', 'facealpha', 1);
    set(gca,'YScale','log')
    xlabel('log(max DoG intensity + 1) (au)')
    ylabel('frequency')
    title(Prefix, 'Interpreter', 'none')
    standardizeFigure(gca, [], color{1}, 'fontSize', 14);
    
  
end