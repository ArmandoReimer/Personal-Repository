%This function will sequentially call up traces and prompt the user to
%manually call start and end frames of peaks. Press "q" to call a trace
%basal, "s" to skip, or any other key to indicate active. 

function ChooseBasal(dataTab)
  close all
  name = strcat('basalParticles_',string(dataTab),'.mat');

  %%Load data and define variables
  data = LoadMS2Sets(dataTab);
  nSets = length(data);
  chn = 1;
  Fig = figure();
  if ~isfile(name)
     basalParticles = cell([1 nSets]); 
     activeParticles = cell([1 nSets]);
     OnOffFrames = cell([1 nSets]);
     integratedactive =cell([1 nSets]);
     ncAssignment = cell([1 nSets]);
  else
      disp('Loading previous file.')
      load(name);
 end
     
  %%Analyze
    for dataSet = 1:nSets
        %Check for previously saved data. Start at first empty set.
        if isempty(basalParticles{dataSet}) & isempty(activeParticles{dataSet})
           numParticles = length(data(dataSet).CompiledParticles{chn});
            for particle = 1:numParticles
                 frame = data(dataSet).CompiledParticles{chn}(particle).Frame;
                 fluo = data(dataSet).CompiledParticles{chn}(particle).FluoGauss;
                 ElapsedTime = data(dataSet).ElapsedTime;
                %Determine nuclear cycle.
                 NCs = [data(dataSet).nc10,data(dataSet).nc11,data(dataSet).nc12,data(dataSet).nc13,data(dataSet).nc14];
                 nc = find(frame(1)>NCs,1,'last') + 9;
                 ncAssignment{dataSet} = [ncAssignment{dataSet}, nc];
                %Choose which particles are basal.
                 plot(frame,fluo)
                 title('Particle intensity over time')
                 ylim([0 800]);
                 vline([70 80],{'r','r'},{'start','end'})
                 waitforbuttonpress
                 if Fig.CurrentCharacter == 'q'
                     basalParticles{dataSet} = [basalParticles{dataSet}, particle];
                     data(dataSet).CompiledParticles{chn}(particle).Basal = 1;
                 elseif Fig.CurrentCharacter == 's'
                     disp('Skipping particle.')
                %And which are active.             
                 else
                     activeParticles{dataSet} = [activeParticles{dataSet}, particle];
                     data(dataSet).CompiledParticles{chn}(particle).Basal = 0;
                     %Integrate intensity of active particles.
                     try 
                         start = input('Where should the integration begin?');
                         fin = input('And where should it end?');   
                         startindex = find(frame == start);
                         finindex = find(frame == fin);
                         Intensity = fluo(startindex:finindex);
                         time = ElapsedTime(frame(startindex:finindex)); 
                         intIntensity = trapz(time,Intensity); 
                         %If you enter a frame that doesn't exist, it errors out.
                         if intIntensity == 0
                            error('Try again.')
                         else
                         OnOffFrames{dataSet} = [OnOffFrames{dataSet},[start,fin,particle]];
                         integratedactive{dataSet} = [integratedactive{dataSet}, intIntensity];
                         end
                         %Check if there's this weird behavior of having
                         %multiple of the same integrated intensity value.
                         if any(intIntensity == integratedactive{dataSet})
                             warning('Duplicate integrations being stored.')
                         end
                     catch 
                         frame
                         start = input('Where should the integration begin?');
                         fin = input('And where should it end?');  
                         startindex = find(frame == start);
                         finindex = find(frame == fin);
                         Intensity = fluo(startindex:finindex);
                         time = ElapsedTime(frame(startindex:finindex)); 
                         intIntensity = trapz(time,Intensity);
                         OnOffFrames{dataSet} = [OnOffFrames{dataSet},[start,fin,particle]];
                         %Check if there's this weird behavior of having
                         %multiple of the same integrated intensity value.
                         if any(intIntensity == integratedactive{dataSet})
                             warning('Duplicate integrations being stored.')
                         end
                         integratedactive{dataSet} = [integratedactive{dataSet}, intIntensity];
                     end
                     
                 end
                
            end
    %Save between data sets. 
    disp(strcat('Saving ', num2str(dataSet)))
    save(name,'basalParticles','activeParticles','integratedactive','OnOffFrames','data','ncAssignment');
      end
end