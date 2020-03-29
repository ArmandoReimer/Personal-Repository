

%reformatted version of the arff file. an n x d matrix where d is the number of features and n is the number of pixels trained. 
 %label class. n x 1. this is comparable to the last column in the arff file. usually foreground/background boolean



Prefix = '2020-01-21-1Dg-8D_EfEfEf_9';

[~, ProcPath, DropboxFolder, ~, PreProcPath] = DetermineLocalFolders(Prefix);

dataRoot = fileparts(PreProcPath);
mlFolder = [dataRoot, filesep, 'training_data_and_classifiers', filesep];

[trainingNameExt, trainingFolder] = uigetfile([mlFolder, filesep, '*.*']);
trainingFile = [trainingFolder, filesep, trainingNameExt];
[~ ,trainingName] = fileparts(trainingNameExt);
%%






arffLoader = javaObject('weka.core.converters.ArffLoader'); %this constructs an object of the arffloader class
arffLoader.setFile(javaObject('java.io.File',trainingFile)); %construct an arff file object
trainingData= arffLoader.getDataSet;
trainingData.setClassIndex(trainingData.numAttributes - 1);

[data,attributes,classIndex] = weka2matlab(trainingData);
numAttributes = classIndex - 1;
trainingResponse = data(:, classIndex); 
data = data(:, 1:numAttributes);


B = TreeBagger(64,data,trainingResponse,'OOBPredictorImportance','Off', 'Method','classification');

clear data; clear trainingResponse; clear trainingData; clear arffLoader;

testData = [];
Yfit = predict(B,testData);
