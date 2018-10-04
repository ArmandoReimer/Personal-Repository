function downsample_traces()
    close all force

    project = 'mcp_opt';
    data_sets = LoadMS2Sets(project); 
    montpath = 'E:\Armando\Figures\downsampled_figures';
    for set = 1:length(data_sets)
        cp =  data_sets(set).CompiledParticles;
        for particle = 1:length(cp)
            elapsed_time = 9.6*(cp(particle).Frame - cp(particle).Frame(1)); %9.6s sampling rate. 
            intensity = cp(particle).Fluo; 
            ds_time = downsample(elapsed_time,4);
            ds_intensity = downsample(intensity,4);
            fig = figure();
            disp(['plotting particle ', num2str(particle), ' of dataset ', num2str(set)])
            plot(ds_time, ds_intensity)
            hold on
            plot(elapsed_time, intensity)
            hold off
            title(['AP: ',num2str(cp(particle).MeanAP),'. ',num2str(particle), ' of dataset ', num2str(set)])
            xlabel('Elapsed time (min)')
            ylabel('Intensity (a.u.)')
            leg = legend('10s', '40s');
            standardizeFigure(gca, leg)
            saveas(fig, [montpath, filesep, 'set',num2str(set),'particle',num2str(particle),'.png'])
            close all;
        end
    end
%     montdir = dir([montpath,filesep,'*.png']);
%     imnames = {[montdir.folder(1),filesep,montdir.name]}';
%     montage(imnames);
    fileFolder = 'E:\Armando\Figures\downsampled_figures';
    currentFol = pwd;
    cd(fileFolder)
    dirOutput = dir(fullfile(fileFolder,'*.png'));
    fileNames = {dirOutput.name}';
    montage(fileNames)
    cd(currentFol);
    
end

