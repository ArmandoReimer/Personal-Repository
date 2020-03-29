try
%this is just some function that can only be called if IJM is set up
IJM.getIdentifier() 
catch
    addpath([MS2CodePath,filesep,'Fiji.app',filesep,'scripts'])
    ImageJ               % Initialize IJM and MIJ
end
%pull the IJM and MIJ objects created from the ImageJ call to the function
%workspace
ijm = evalin('base', 'IJM');
mij = evalin('base', 'MIJ');
%Do the classification with Weka in Fiji
mij.run('Trainable Weka Segmentation 3D', ['open=',rawStackName]);
%not sure if this pause is 100% needed
pause(10);
%this is the function call that does the job of generating feature stacks
%and performing the classification
trainableSegmentation.Weka_Segmentation.loadClassifier([classifierFolder, classifierPathCh1]);
%generate probability maps from the original image. this can be made binary
%by thresholding pixels over 50% probability
trainableSegmentation.Weka_Segmentation.getProbability();
ijm.getDatasetAs('probmaps')
pMapTemp = evalin('base', 'probmaps');
pMap = [];
for m = 1:2:zSize2
    pMap(:,:,ceil(m/2)) =  pMapTemp(:,:,m); %the even images in the original array are negatives of the odds
end
clear pMapTemp;
pMap = permute(pMap, [2 1 3]) * 10000; %multiplying so this can be cast to uint16
for i = 1:size(pMap, 3)
    p_name = ['prob',Prefix,'_',iIndex(current_frame,3),'_z',iIndex(i,2),nameSuffix,'.tif'];
    imwrite(uint16(pMap(:,:,i)), [OutputFolder1,filesep,p_name])               
end
mij.run('Close All');
clear pMap;
