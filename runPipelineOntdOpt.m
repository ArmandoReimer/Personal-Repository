segmentSpots(Prefix1, 10300, 'intScale', 2)
segmentSpots(Prefix2, 10300, 'intScale', 2)
segmentSpots(Prefix3, 10150, 'intScale', 2)
segmentSpots(Prefix4, 10250, 'intScale', 2)
segmentSpots(Prefix5, 10200, 'intScale', 2)
segmentSpots(Prefix6, 10200, 'intScale', 2)
n = 6;
for i = 3:n
    prefix = ['2018-07-12-1A3v7L16_td_opt_',num2str(i)];
    segmentSpotsML(prefix,[], 'tifs')
%     TrackmRNADynamics(prefix, 2, 2)
%     CompileParticles(prefix, 'ApproveAll')
end