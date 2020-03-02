warning('off', 'MATLAB:Java:DuplicateClass');
warning('off', 'MATLAB:javaclasspath:jarAlreadySpecified');


load('E:\DorsalSynthetics\Data\PreProcessedData\2020-01-21-1Dg-8D_EfEfEf_9\2020-01-21-1Dg-8D_EfEfEf_9_hisMat.Mat')
arffFile =  'E:\classifiers backup 9-20-19\classifiers\nuclear\70nmgood.arff';
ramDrive = 'R:\';

hisMat = double(hisMat);
nFrames = size(hisMat, 1);

pMap = zeros(size(hisMat, 1), size(hisMat, 2), size(hisMat, 3));

%only need to make the classifier from training data

%once and not every frame
arffloader = javaObject('weka.core.converters.ArffLoader'); %this constructs an object of the arffloader class
arffloader.setFile(javaObject('java.io.File',arffFile)); %construct an arff file object
trainingData= arffloader.getDataSet;
trainingData.setClassIndex(trainingData.numAttributes - 1);
%%
classifier = javaObject('hr.irb.fastRandomForest.FastRandomForest');
options = {'-I', '64', '-threads', '1', '-K', '2', '-S', '-1650757608', '-depth', '20'};
%  classifier = weka.classifiers.trees.RandomForest;
%  options = {'-I', '64', '-K', '2', '-S', '-1650757608','-depth', 20};

classifier.setOptions(options);
classifier.buildClassifier(trainingData);
save( 'E:\classifiers backup 9-20-19\classifiers\nuclear\70nmgood_no_fiji.model', 'classifier')
% 
% hisMat_constant = parallel.pool.Constant(hisMat);
% classifier_constant = parallel.pool.Constant(classifier);
% trainingData_constant = parallel.pool.Constant(trainingData);

% wrapper = WorkerObjWrapper();


profile off
profile on
% wb = waitbar(0, 'classifying frames');
% set(wb, 'units', 'normalized', 'position', [0.4, .4, .25,.1]);
dT = [];



% parpool(10);
for f = 1:nFrames
    
    tic
    if f~=1, tic, disp(['Making probability map for frame: ', num2str(f),...
            '. Estimated ', num2str(mean(dT)*(nFrames-f)), ' minutes remaining'])
    end
    im = squeeze(hisMat(f, :, :));
    pMap(f, :, :) = classifyImage(im, trainingData,'tempPath', ramDrive, 'reSc', true, 'classifierObj', classifier);
    waitbar(f/nFrames, wb);
    dT(f)=toc/60;
    
%     tic
%     if f~=1, tic, disp(['Making probability map for frame: ', num2str(f)]);
%     end
%     im = double(squeeze(hisMat(f, :, :)));
%     pMap(f, :, :) = classifyImage(im, arffFile,'tempPath', ramDrive, 'reSc', true, 'classifierObj', classifier);
%     waitbar(f/nFrames, wb);
%     dT(f)=toc/60

%     tic
%     if f~=1, tic, disp(['Making probability map for frame: ', num2str(f)]);
%     end
%     im = double(squeeze(hisMat_constant.Value(f, :, :)));
%     pMap(f, :, :) = classifyImage(im, trainingData,'tempPath', ramDrive, 'reSc', true, 'classifierObj', classifier_constant.Value);
% %     waitbar(f/nFrames, wb);
%     dT(f)=toc/60
    
end

close(wb);

save('E:\DorsalSynthetics\Data\PreProcessedData\2020-01-21-1Dg-8D_EfEfEf_9\2020-01-21-1Dg-8D_EfEfEf_9_pHis.mat', '-v7.3', '-nocompression')

profile viewer
profsave(profile('info'),'E:\classifiers backup 9-20-19\classifiers\nuclear\')
profile off
%%