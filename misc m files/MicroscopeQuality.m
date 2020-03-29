function [Fluo2Offset,Fluo2Error,FluoErrors]=MicroscopeQuality(Prefix)

%Obtain the signal to background and signal to noise quantities during the
%maximum fluorescence period of nc14.

[SourcePath,FISHPath,DropboxFolder,MS2CodePath,SchnitzcellsFolder]=...
    DetermineLocalFolders(Prefix);


Data=load([DropboxFolder,filesep,Prefix,filesep,'CompiledParticles.mat']);


%Figure out the time of maximum expression in nc14
TimeWindow=1.5;       %In minutes
if Data.nc14>0
    MaxValue=max(Data.MeanVectorAll(Data.nc14:end));
else
    MaxValue=max(Data.MeanVectorAll);
end
MaxIndex=find(Data.MeanVectorAll==MaxValue);

if unique(Data.ElapsedTime)==0
    warning('There might be a problem with the time stamps. Assuming a time step of 10s.')
    Data.ElapsedTime=[0:1:(length(Data.ElapsedTime)-1)]*10/60;
end

WindowLeftIndex=min(find((Data.ElapsedTime-Data.ElapsedTime(MaxIndex))>(-TimeWindow)));
WindowRightIndex=min(find((Data.ElapsedTime(MaxIndex)-Data.ElapsedTime)<(-TimeWindow)));

yRange=linspace(0,max(Data.MeanVectorAll)*1.1);

figure(1)
if Data.nc14>0
    plot(Data.ElapsedTime(Data.nc14:end),Data.MeanVectorAll(Data.nc14:end))
else
    plot(Data.ElapsedTime,Data.MeanVectorAll)
end
hold on
plot(Data.ElapsedTime(WindowLeftIndex)*ones(size(yRange)),yRange,'--k')
plot(Data.ElapsedTime(WindowRightIndex)*ones(size(yRange)),yRange,'--k')
hold off


Fluo2Offset=[];
Fluo2Error=[];
FluoErrors=[];
for i=1:length(Data.CompiledParticles)
    if (Data.CompiledParticles(i).FluoError>0)
        %Filter the right frames
        FrameFilter=(Data.CompiledParticles(i).Frame>=WindowLeftIndex)&...
            (Data.CompiledParticles(i).Frame<=WindowRightIndex);
             
        if ~isnan(median(Data.CompiledParticles(i).Fluo(FrameFilter)./...
            (Data.CompiledParticles(i).Off(FrameFilter))))
            %Ratio of signal to offset
            Fluo2Offset(end+1)=median(Data.CompiledParticles(i).Fluo(FrameFilter)./...
                (Data.CompiledParticles(i).Off(FrameFilter)));

            %Ratio of signal to error
            Fluo2Error(end+1)=median(Data.CompiledParticles(i).Fluo(FrameFilter)./...
                (Data.CompiledParticles(i).FluoError));

            FluoErrors(end+1)=Data.CompiledParticles(i).FluoError;
        end
    end
end
