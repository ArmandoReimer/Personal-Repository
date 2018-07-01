function dogHists(Prefix, nBins)
    
    dogDirPath = ['E:\Armando\LivemRNA\Data\ProcessedData\',Prefix,'_\dogs\DOG*.tif'];
    dogDir = dir(dogDirPath);
    numIm = length(dogDir);
    vals = [];
    for i = 3:numIm
        dog = imread([dogDirPath, filesep, dogDir(i).name]);
        vals(i) = log(double(max(dog(:))) + 1);
        %imshow(dog, []);
    end
    histogram(vals,nBins,'Normalization','probability');
    % histfit(vals);
    set(gca,'YScale','log')
    xlabel('ln(max DoG intensity + 1) (au)')
    ylabel('frequency')
    title(Prefix)
    standardizeFigure(gca, [], 'red', 'lightblue', 'fontSize', 14);
    
end