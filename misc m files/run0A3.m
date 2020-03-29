prefixes0A3 = {'2019-05-17-0A3v7lacZ_2','2019-05-17-0A3v7lacZ_3','2019-05-17-0A3v7lacZ_4', '2019-05-17-0A3v7lacZ_5', '2019-05-17-0A3v7lacZ_6'};
for i = 1:length(prefixes0A3)
    prefix = prefixes0A3{i};
%     if i ~=1
        segmentSpots(prefix,0.5,'intScale', 1.5, 'Shadows', 2, 'keepPool', 'nWorkers', 8, '.mat', 'keepProcessedData', 'fit3D');
%     end
    TrackmRNADynamics(prefix, 'noRetracking')
end