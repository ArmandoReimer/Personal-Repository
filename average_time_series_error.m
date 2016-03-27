function [time_bins, mean_datas] = average_time_series_error(data,err)


for i = 1:length(data)
    data(i).ElapsedTime = data(i).ElapsedTime - data(i).ElapsedTime(data(i).nc14);
    datas{i} = data(i).SDVectorAll(data(i).nc14:end) ./ length(data);
    times{i} = data(i).ElapsedTime(data(i).nc14:end);
end

time_bins = 0:.4:45;
data_bins = cell(1,length(time_bins));

for i = 1:length(datas)
    for j = 1:length(datas{i})
        for k = 1:length(time_bins)
            if times{i}(j) < time_bins(k)
                data_bins{k-1} = [data_bins{k-1},datas{i}(j)];
                break;
            end
        end
    end
end

mean_datas = NaN(1,length(data_bins));
for i=1:length(data_bins)
    mean_datas(i) = nanmean(data_bins{i});
end
    
                    