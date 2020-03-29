close all force;
profile off
profile on
tic
% load('E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2\2018-08-31-1A3v7L16_mcp_opt_12\beta.mat')
% load('E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2\2018-08-31-1A3v7L16_mcp_opt_12\features.mat')
load('E:\Armando\LivemRNA\Data\Dropbox\DynamicsResults\2015-07-25-P2P_75uW_bi_short\beta.mat')
load('E:\Armando\LivemRNA\Data\Dropbox\DynamicsResults\2015-07-25-P2P_75uW_bi_short\features.mat')
sigmaVec = num2cell(1:8);
% classifyAllFrames(Prefix12, trainingFeatures, sigmaVec, beta)
filterImageFrames(prefixP2PTest,sigmaVec,trainingFeatures, beta);
toc
profile viewer