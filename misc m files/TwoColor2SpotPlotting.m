%Make the calibration curve
%note for AR: need to write a way to only plot points common to red and
%green
calR = [];
calG = [];
for i = 1:length(CompiledParticles{1})
    for j = 1:length(CompiledParticles{2})
        if CompiledParticles{1}(i).Nucleus == CompiledParticles{2}(j).Nucleus
            for k = 1:length(CompiledParticles{1}(i).Frame)
                for l = 1:length(CompiledParticles{2}(j).Frame)
                    if CompiledParticles{1}(i).Frame(k) == CompiledParticles{2}(j).Frame(l)
                        calG = [calG,CompiledParticles{1}(i).Fluo(k)];
                        calR = [calR,CompiledParticles{2}(j).Fluo(l)];
                    end
                end
            end
        end
    end
end
scatter(calR, calG);
ylim([0,3000])
xlim([0,3000])
xlabel('red')
ylabel('green')


%Look at the raw traces
for i = 1:length(CompiledParticles{1})
    for j = 1:length(CompiledParticles{2})
        if CompiledParticles{1}(i).Nucleus == CompiledParticles{2}(j).Nucleus && length(CompiledParticles{2}(j).Frame) > 5
            figure
            yyaxis left
            plot(CompiledParticles{1}(i).Frame,CompiledParticles{1}(i).Fluo)
            yyaxis right
            plot(CompiledParticles{2}(j).Frame,CompiledParticles{2}(j).Fluo)
            waitforbuttonpress            
        end
    end
end
close all force;