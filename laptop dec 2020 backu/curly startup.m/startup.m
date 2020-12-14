isheadless = false;

%% headless
%% headed


%mrnadynamics pipeline
addpath(genpath('X:/Armando/LivemRNA/mRNADynamics\lib\Fiji.app\scripts')); 
path('X:/Armando/LivemRNA\Data\PreProcessedData',path); 
path('X:/Armando/LivemRNA',path); 
path('X:/Armando/LivemRNA/mRNADynamics',path); 
addpath(genpath('X:/Armando/LivemRNA/mRNADynamics\src')); 
path('X:/Armando/LivemRNA\Data\DynamicsResults',path); 
addpath(genpath('X:/Armando/LivemRNA/mRNADynamics\test')); 
addpath(genpath('X:/Armando/LivemRNA/mRNADynamics\lib/dependencies'));


%additional things i want
addpath(genpath('S:\Armando\Dropbox/DorsalSyntheticsDropbox')); 
addpath(genpath('X:\Armando\Personal-Repository')); 
addpath(genpath('S:\Armando\Dropbox\non-git_code'))
addpath(genpath('X:\Armando\tf_enrichment_pipeline'));
addpath(genpath('X:\Armando\Dorsal-Synthetics-Analysis\src'));


% preProcFolder = 'C:/Users/owner/Desktop/LivemRNA\Data\PreProcessedData'; 
% procFolder = 'C:/Users/owner/Desktop/LivemRNA\Data\ProcessedData'; 
%  [~, resultsFolder] = getDorsalFolders;
%  dataType = '1Dg_2xDl';
 Prefix = '2020-01-21-1Dg-8D_EfEfEf_9_small';