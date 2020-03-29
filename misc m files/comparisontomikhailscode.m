close all force;
d = LoadMS2Sets('newcodecomparison');
n = 80;

figure(1)
plot(d(1).MeanVectorAll, d(2).MeanVectorAll, '.')
hold on;
plot(1:2000, 1:2000);
xlabel('Mikhail MeanVectorAll (A.U.)');
ylabel('Armando MeanVectorAll (A.U.)');
legend('Data', 'y = x');

figure(2)
plot(d(1).ElapsedTime, d(1).MeanOffsetVector*100);
hold on
plot(d(2).ElapsedTime, d(2).MeanOffsetVector*100);
legend('Mikhail', 'Armando');
xlabel('Time since nc14 (min)');
ylabel('MeanOffsetVector Intensity (A.U.)');

figure(3)
plot(d(1).ElapsedTime, d(1).MeanVectorAll);
hold on
plot(d(2).ElapsedTime, d(2).MeanVectorAll);
legend('Mikhail', 'Armando');
xlabel('Time since nc14 (min)');
ylabel('MeanVectorAll Intensity (A.U.)');

figure(4)
    for i = 1:length(d(1).CompiledParticles)
        if length(d(1).CompiledParticles(i).Frame)>n
            plot(d(1).CompiledParticles(i).Frame, d(1).CompiledParticles(i).Fluo);
            hold on
            i
            [d(1).CompiledParticles(i).xPos(1), d(1).CompiledParticles(i).yPos(1)]

             xlabel('Time since nc14 (min)');
             ylabel('Intensity (A.U.)');
            title('FISH Traces')
        end
    end
    figure(5)
    for i = 1:length(d(2).CompiledParticles)
        if length(d(2).CompiledParticles(i).Frame)>n
            plot(d(2).CompiledParticles(i).Frame, d(2).CompiledParticles(i).Fluo);
            display(i)
            hold on
            xlabel('Time since nc14 (min)');
            ylabel('Intensity (A.U.)');
            title('segmentSpot traces')
        end
    end
%     
%     figure(6)
%     plot(d(1).CompiledParticles(9).Frame, d(1).CompiledParticles(9).Fluo);
%     hold on
%     plot(d(2).CompiledParticles(3).Frame, d(2).CompiledParticles(3).Fluo);
%     legend('Mikhail', 'Armando');
%     xlabel('Time since nc14 (min)');
%     ylabel('Intensity (A.U.)');
%     
%     figure(7)
%     plot(d(1).CompiledParticles(26).Frame, d(1).CompiledParticles(26).Fluo);
%     hold on
%     plot(d(2).CompiledParticles(15).Frame, d(2).CompiledParticles(15).Fluo);
%     legend('Mikhail', 'Armando');
%     xlabel('Time since nc14 (min)');
%     ylabel('Intensity (A.U.)');
