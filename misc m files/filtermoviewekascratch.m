function classifyImage(im, model, varargin)

%helper functions
paren = @(x, varargin) x(varargin{:}); %emulates the syntax array(i)(j)

%load test data
load('E:\DorsalSynthetics\Data\PreProcessedData\2020-01-21-1Dg-8D_EfEfEf_9\2020-01-21-1Dg-8D_EfEfEf_9_hisMat.Mat')
%normalize data to the max of the training set for better classification
im = double(squeeze(hisMat(1, :, :)));
im = 5*im./max(im(:)); %5 is max of this particular training set

%% initialize weka
javaaddpath('C:\Program Files\Weka-3-8-4\weka.jar','-end')
arffloader = javaObject('weka.core.converters.ArffLoader'); %this constructs an object of the arffloader class

%% load up training data
folder = 'E:\classifiers backup 9-20-19\classifiers\nuclear\';
filename = '70nmgood.arff';
arff = javaObject('java.io.File',[folder, filename]); %construct an arff file object
arffloader.setFile(arff);
d= arffloader.getDataSet;

%% build classifier
c = weka.classifiers.trees.RandomForest;
d.setClassIndex(d.numAttributes - 1)
options = {'-I' '200' '-K' '2' '-S' '-1650757608'};
c.setOptions(options);
c.buildClassifier(d)
c.toString

%% load classifier

% filename = '70nmgood.model';
% modelObj = weka.core.SerializationHelper.read([folder, filesep, filename]);
% 

%% generate features
xDim=size(im, 2); yDim = size(im, 1);
ni = xDim*yDim;
data = zeros(ni, d.numAttributes-1);

attributes = {};
stringVals = {};
% Take attribute names
for i = 0:d.numAttributes()-2
    attributes{i+1} = char(d.attribute(i).name());
    attribute = d.attribute(i);
   %might error with attributes with 2 sigmas. need to fix -AR
    if i
        filterType = regexp(attributes{i+1}, '.*(?=_)', 'match');                                                             
        sigma =  flip(num2str(sscanf(flip(attributes{i+1}), '%f')));
        fim = filterImage(im, filterType{1}, {sigma});
    else
        fim = im;
    end
    
    data(:,i+1) = fim(:);
    
end

%now turn data matrix into weka arff
tic
rFolder= 'R:\';
% rFolder = 'E:\Armando\'
rFile = [rFolder, filesep, 'frame.data'];
save(rFile,'data','-ascii');
toc
loader = javaObject("weka.core.converters.MatlabLoader")

%in the future, i'd like to use RAM for this by mounting up a RAM drive and
%loading/saving from there
%(https://sourceforge.net/projects/imdisk-toolkit/)

loader.setFile(javaObject('java.io.File',rFile));
gD = loader.getDataSet;
gD.insertAttributeAt(d.classAttribute,d.classIndex)
gD.setClassIndex(gD.numAttributes-1)


rD = javaMethod('useFilter','weka.filters.Filter', gD, f); %match test header to training header

nClasses = gD.numClasses;
nInstances = gD.numInstances;

compatible = rD.equalHeaders(d); %check compatability between arff and data
if ~compatible
    error(char(rD.equalHeadersMsg(d)));
end

%this step is unbearably slow. >1min per frame. needs a massive overhaul
p = zeros(gD.numInstances, 1);
waitbarFigure = waitbar(0, 'filtering frame');
set(waitbarFigure, 'units', 'normalized', 'position', [0.4, .15, .25,.1]);
for i = 1:nInstances
    
%     dist = c.distributionForInstance(gD.instance(i - 1));
    p(i) = paren(c.distributionForInstance(rD.instance(i - 1)), 1);
%     p(i) = paren(c.classifyInstance(rD.instance(i - 1)), 1);
    waitbar(i/nInstances, waitbarFigure);

end

pIm = reshape(p, [yDim xDim]);
figure(1); imagesc(im); colorbar;
figure(2); imagesc(pIm); colorbar;