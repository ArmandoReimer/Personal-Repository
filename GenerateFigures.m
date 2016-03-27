function GenerateFigures(varargin)

data=LoadMS2Sets(varargin{1});
%Parameters:
GeneLength5=5.296;      %Distance from the first MS2 site to the end of the
                        %TUB3'UTR in kb for the 5' constrcut.
norm = 0;
plot_title = '';
for i=2:length(varargin)
    switch varargin{i}
        case {'norm'}
            norm = 1;
        case {'title'}
            plot_title = input('Enter title:');
    end
end
        
%% Average fit results
%We'll assume that mRNA's are terminated in a non-random way with a certain
%time delay. The idea is to be able to calculate what part of the average
%signal change is due to transcription initiation by removing the part
%corresponding to termination.

close all
% 
% Constructs arrays of integrated mRNA production and associated error,
% respectively, using formula (pol loading rate) * (transcriptional time
% window = toff - ton).
for i=1:length(data)
    mRNA_AP=nan(length(data),length(data(i).APbinID),3);
    SD_mRNA_AP=nan(length(data),length(data(i).APbinID),3);
    for j=1:length(data(i).APbinID)
        for k=1:2
            if (~isempty(data(i).MeanFits(j,k).RateFit))&&(data(i).MeanFits(j,k).Approved==1)
                syms r
                rate = data(i).MeanFits(j,k).RateFit;
                t_off = data(i).MeanFits(j,k).TimeEnd;
                t_on = data(i).MeanFits(j,k).TimeStart;
                [mRNA_AP(i,j,k), SD_mRNA_AP(i,j,k)] = PropError(r*(t_off-t_on),[r], [rate], [data(i).MeanFits(j,k).SDRateFit]);
            end
        end
    end
end

if norm
    for k=1:size(mRNA_AP,3)
        max_val = max(mRNA_AP(:,:,k));
        mRNA_AP(:,:,k) = mRNA_AP(:,:,k) ./ max_val;
        SD_mRNA_AP(:,:,k) = SD_mRNA_AP(:,:,k) ./ max_val;
    end
end


%Constructs arrays of integrated mRNA production and associated error,
%respectively, using formula found in SI of (Bothma, 2014).
% 
% for i=1:length(data)
%     mRNA_AP_J=nan(length(data),length(data(i).APbinID),3);
%     SD_mRNA_AP_J=nan(length(data),length(data(i).APbinID),3);
%     for j=1:length(data(i).APbinID)
%         for k=1:2
%             if (~isempty(data(i).MeanFits(j,k).RateFit))&(data(i).MeanFits(j,k).Approved==1)
%                 rate = data(i).MeanFits(j,k).RateFit;
%                 delay = GeneLength5/rate;
%                 t_off = data(i).MeanFits(j,k).TimeEnd;
%                 t_on = data(i).MeanFits(j,k).TimeStart;
%                 syms r toff ton;
%                 [ mRNA_AP_J(i,j,k), SD_mRNA_AP_J(i,j,k)] = PropError( (2 / (GeneLength5/r)) * (.5*( (toff - GeneLength5/r) + (toff - ton + GeneLength5/r) ) * GeneLength5),[toff, ton, r], [t_off, t_on, rate], [data(i).MeanFits(j,k).SDTimeEnd,data(i).MeanFits(j,k).SDTimeStart, data(i).MeanFits(j,k).SDRateFit]);
%             end
%         end
%     end
% end
 
%Generate the weighted averages for the rate
% for i=1:length(data)
% mRNA_weight=nan(length(data(1).APbinID),3);
% SD_mRNA_weight=nan(length(data(1).APbinID),3);
% SE_mRNA_weight=nan(length(data(1).APbinID),3);
% for j=1:length(data(1).APbinID)
%     for k=1:3
%         NanFilter=~(isnan(mRNA_AP(:,j,k))|isnan(SD_mRNA_AP(:,j,k)));
%         
%         if sum(NanFilter)>=MinEmbryos
%        
%             mRNA_weight(j,k)=mean(mRNA_AP(NanFilter,j,k));
%             SD_mRNA_weight(j,k)=std(mRNA_AP(NanFilter,j,k));
%             SE_mRNA_weight(j,k)=std(mRNA_AP(NanFilter,j,k))/sqrt(sum(NanFilter));
%         end
%     end
% end 
 
   
 
%Overlay single rates and mean rate
figure(1)
clf
PlotHandle=[];
hold on

for nc=12:13
    for i=1:length(data)
           PlotHandle(end+1)=errorbar(data(1).APbinID,mRNA_AP(i,:,nc-11),SD_mRNA_AP(i,:,nc-11),'Color','r');
    end
end

% PlotHandle(end+1)=errorbar(data(1).APbinID,mRNAWeight(:,nc-11),SDWeight(:,nc-11),'.-r');
xRange=linspace(0,1);
% plot(xRange,ones(size(xRange))*(RateNoBcdWeight(nc-11)+SERateNoBcdWeight(nc-11)),'--r')
% plot(xRange,ones(size(xRange))*(RateNoBcdWeight(nc-11)-SERateNoBcdWeight(nc-11)),'--r')
hold off
box on
xlim([0,1])
ylim([0,1.25*max(mRNA_AP(:, :, 13-11))])
xlabel('AP position (x/L)')
ylabel('Accumulated mRNA (fu)')
StandardFigure(PlotHandle,gca)
if exist(plot_title)
    title(['mRNA Produced in nc',num2str('13x2,14')])
else
    title([plot_title])
end

 