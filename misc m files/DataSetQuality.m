function [Fluo2Offset,Fluo2Error,FluoErrors] = DataSetQuality(Prefix, nc)

%Obtain the signal to background and signal to noise quantities during the
%maximum fluorescence period. 

[SourcePath,FISHPath,DropboxFolder,MS2CodePath,SchnitzcellsFolder]=...
    DetermineLocalFolders(Prefix);
% DLIF=dir([Folder,filesep,'*.lif']);
% NSlices = str2num(LIFMeta.getPixelsSizeZ(1));
% 
% %Load the file using BioFormats
%         %Figure out which one is not the FF
%         LIFIndex=find(cellfun(@isempty,strfind({DLIF.name},'FF')));
%         %Load the data, this might cause problems with really large sets
%         LIFImages=bfopen([Folder,filesep,DLIF(LIFIndex).name]);
%         %Extract the metadata for each series
%         LIFMeta = LIFImages{:, 4};

Data=load([DropboxFolder,filesep,Prefix,filesep,'CompiledParticles.mat']);
   
%Figure out the time of maximum expression in nc14
TimeWindow=2;       %In minutes
switch nc
    case 14
    if Data.nc14>0
        MaxValue=max(Data.MeanVectorAll(Data.nc14:end));
    else
        MaxValue=max(Data.MeanVectorAll);
    end
    case 13
        if Data.nc13>0 && ~isnan(Data.nc14)
            MaxValue=max(Data.MeanVectorAll(Data.nc13:Data.nc14));
        elseif Data.nc13>0 
            MaxValue=max(Data.MeanVectorAll(Data.nc13:end));
        else
            MaxValue=max(Data.MeanVectorAll);
        end 
    case 12
          if Data.nc12>0
            MaxValue=max(Data.MeanVectorAll(Data.nc12:nc13));
          else
            MaxValue=max(Data.MeanVectorAll);
          end
    otherwise 
        error('Please provide nuclear cycle you want to analyze')
end
        
MaxIndex=find(Data.MeanVectorAll==MaxValue);

if unique(Data.ElapsedTime)==0
    warning('There might be a problem with the time stamps. Assuming a time step of 10s.')
    Data.ElapsedTime=[0:1:(length(Data.ElapsedTime)-1)]*10/60;
end

WindowLeftIndex=min(find((Data.ElapsedTime-Data.ElapsedTime(MaxIndex))>(-TimeWindow)));
WindowRightIndex=min(find((Data.ElapsedTime(MaxIndex)-Data.ElapsedTime)<(-TimeWindow)));

yRange=linspace(0,max(Data.MeanVectorAll)*1.1);

% figure()
% if Data.nc13>0
%     plot(Data.ElapsedTime(Data.nc13:end),Data.MeanVectorAll(Data.nc13:end))
% else
%     plot(Data.ElapsedTime,Data.MeanVectorAll)
% end
% hold on
% plot(Data.ElapsedTime(WindowLeftIndex)*ones(size(yRange)),yRange,'--k')
% plot(Data.ElapsedTime(WindowRightIndex)*ones(size(yRange)),yRange,'--k')
% hold off

TimeFilter = 3;
Fluo2Offset=[];
Fluo2Error=[];
FluoErrors=[];

for i=1:length(Data.CompiledParticles)
    if length(Data.CompiledParticles(i).Frame) > TimeFilter
        if (Data.CompiledParticles(i).FluoError>0)
            %Filter the correct frames
            FrameFilter=(Data.CompiledParticles(i).Frame>=WindowLeftIndex)&...
                (Data.CompiledParticles(i).Frame<=WindowRightIndex);

            if ~isnan(nanmedian(Data.CompiledParticles(i).Fluo(FrameFilter)./...
                (Data.CompiledParticles(i).Off(FrameFilter))))
                %Ratio of signal to offset
                Fluo2Offset(end+1)=nanmedian(Data.CompiledParticles(i).Fluo(FrameFilter)./...
                    (Data.CompiledParticles(i).Off(FrameFilter)));

                %Ratio of signal to error
                Fluo2Error(end+1)=nanmedian(Data.CompiledParticles(i).Fluo(FrameFilter)./...
                    (Data.CompiledParticles(i).FluoError));

                FluoErrors(end+1)=Data.CompiledParticles(i).FluoError;
            end
        end
    end
end

