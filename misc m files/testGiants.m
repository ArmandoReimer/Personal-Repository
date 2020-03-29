profile off
profile on
% firstFrame = 2;
% lastFrame = 51;
% numFrames = (lastFrame - firstFrame) + 1;
padSize = 12;
% format = [256, 256, 23];
format = [768, 768, 21];
% stacksPath = 'E:\Armando\LivemRNA\Data\PreProcessedData\2015-07-25-P2P_75uW_bi_short\stacks';
% stacksPath = 'E:\SyntheticEnhancers\Data\PreProcessedData\2018-08-31-1A3v7L16_mcp_opt_10\stacks';
stacksPath = 'E:\SyntheticEnhancers\Data\PreProcessedData\2018-08-31-1A3v7L16_mcp_opt_10\';
Prefix = '2018-08-31-1A3v7L16_mcp_opt_10';
channel = 1;
d = dir([stacksPath, '\*.tif']);
nFrames = length(d);
nFrames = 357;
chunkSize = 30;
chunks = [1:chunkSize:nFrames, nFrames+1];
tic
for i = 1:length(chunks)-1
    g = makeGiantImage(stacksPath, format, padSize, chunks(i), chunks(i+1)-1, Prefix, channel);
    gt = permute(g, [2 1 3]);
    gdog = filterImage(gt, 'Difference_of_Gaussian',{1,4});
    gdogt = permute(gdog, [2 1 3]);
    extractFromGiant(gdogt, format, padSize, chunks(i), chunks(i+1)-1);
end
toc
profile viewer
