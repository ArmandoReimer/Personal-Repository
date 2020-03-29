data = LoadMS2Sets('P2POreR_124uW_bidirectional');
num_sets = length(data);
mean_max = zeros(1,num_sets);
maxs = [];
for i = 1:num_sets
	num_particles = 0;
	sum = 0;
    for j = 1:length(data(i).CompiledParticles)
        all_frames = data(i).CompiledParticles(j).Frame;
        fluos = data(i).CompiledParticles(j).Fluo;
        nc14_fluos = fluos(all_frames > data(i).nc14);
		if length(nc14_fluos) > 20
            [pky,pkx]= findpeaks(nc14_fluos);
            [m,~] = max(pky);
            maxs(j) = m;
			sum = sum + m;
			num_particles = num_particles + 1;
        else 
            maxs(j) = NaN;
        end
        mean_max(i) = sum / num_particles;
    end
end
figure(1)
histogram(mean_max, floor(range(mean_max)/100))
rng default;
bootstrp(length(data),@mean, mean_max)
me = mean(mean_max); %#ok<*NOPTS>
s = std(mean_max);
e = s / me * 100;
legend(['Mean = ',num2str(me),char(10), 'Mean_boot = ',num2str(mean(bootstrp(length(data),@mean, mean_max))),char(10), 'Std. Dev. = ',num2str(s), char(10),'Std. Dev./Mean = ', num2str(e), '%', char(10),'Std_boot =', num2str(std(bootstrp(length(data),@mean, mean_max)))])
title('Distribution of max fluorescence values at nc14 in P2POreRs illuminated at 55uW, bidirectional') 
xlabel('Average peak fluorescence (A.U.)')
ylabel('Counts')