data = LoadMS2Sets('2A310_2016');
cum = zeros(4,41);

for j = 1:length(data)
    fluo = data(j).MeanVectorAP;
    fluo(isnan(fluo)) = 0;
    for i = 1:size(fluo,2)
        cum(j,i) = nansum(fluo(:,i));
                %cum(j,i) = trapz(data(j).ElapsedTime,fluo(:,i));
    end
end

cummean = zeros(1,41);
cumsd = zeros(1,41);
for i = 1:length(cum)
    cummean(1, i) = nanmean(cum(:,i));
    cumsd(1, i) = nanstd(cum(:,i));
    if cummean(i) == 0
        cummean(i) = NaN;
    end
     if cumsd(i) == 0
        cumsd(i) = NaN;
    end
end

%y = (-1.9E4 ./ (1+exp(-(.3*10^2.*(data(1).APbinID - 0.32))))) + 2*10^4
plot(data(1).APbinID, cummean)
%hold on
%plot(data(1).APbinID,y)
