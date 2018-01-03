
gThreshold=50;
rThreshold=14;
%4/24 20s movie: use thresh = 20 red.  thresh = 50 green. for green skip
%first frame

fivename = 'D:\Data\Simon\LivemRNA\Data\RawDynamicsData\2017-04-24\MAX_P2P_MS2_LacZ_PP7.lif - Series009 - C=0.tif';
info = imfinfo(fivename);
num_images = numel(info);
for k = 1:num_images
    Image = imread(fivename, k, 'Info', info);
    ImThresh=Image>gThreshold;
    ImLabel=bwlabel(ImThresh);
    NSpots5(k)=max(max(ImLabel));
end
threename = 'D:\Data\Simon\LivemRNA\Data\RawDynamicsData\2017-04-24\MAX_P2P_MS2_LacZ_PP7.lif - Series009 - C=1.tif';
info = imfinfo(threename);
num_images = numel(info);
for k = 1:num_images %starts at 2 because i didn't like first image in the time series
    Image = imread(threename, k, 'Info', info);
    ImThresh=Image>rThreshold;
    ImLabel=bwlabel(ImThresh);
    NSpots3(k)=max(max(ImLabel));
end

Time5=(1:num_images)*20;        %In seconds
plot(Time5,NSpots5,'-g')
xlabel('Time (s)')
ylabel('Nspots')
Time3=(1:num_images)*20;        %In seconds
hold on
plot(Time3,NSpots3,'-r')
hold off
legend('3','5')
xlim([100,2000])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calibration Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gThreshold=50;
rThreshold=18;
%4/25 20s calibration movie: use thresh = 20 red.  thresh = 50 green. for green skip
%first frame

pcpname = 'D:\Data\Simon\LivemRNA\Data\RawDynamicsData\2017-04-25\P2P_MS2-PP7-LacZ_20sec\MAX_P2P_MS2-PP7-LacZ_20sec.lif - Series007 - C=0 green.tif';
info = imfinfo(pcpname);
num_images = numel(info);
for k = 1:num_images
    Image = imread(pcpname, k, 'Info', info);
    ImThresh=Image>gThreshold;
    ImLabel=bwlabel(ImThresh);
    NSpotsPCP(k)=max(max(ImLabel));
end
MCPname = 'D:\Data\Simon\LivemRNA\Data\RawDynamicsData\2017-04-25\P2P_MS2-PP7-LacZ_20sec\MAX_P2P_MS2-PP7-LacZ_20sec.lif - Series007 - C=1 red.tif';
info = imfinfo(MCPname);
num_images = numel(info);
for k = 1:num_images %starts at 2 because i didn't like first image in the time series
    Image = imread(MCPname, k, 'Info', info);
    ImThresh=Image>rThreshold;
    ImLabel=bwlabel(ImThresh);
    NSpotsMCP(k)=max(max(ImLabel));
end

figure(2)
TimePCP=(1:num_images)*20;        %In seconds
plot(TimePCP,NSpotsPCP,'-g')
xlabel('Time (s)')
ylabel('Nspots')
TimeMCP=(1:num_images)*20;        %In seconds
hold on
plot(TimeMCP,NSpotsMCP,'-r')
hold off
legend('PCP','MCP')
xlim([800,1200])
ylim([0, 60])


%%%%%%%%%%%%%%%10s Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%

gThreshold=50;
rThreshold=14;
%4/24 20s movie: use thresh = 20 red.  thresh = 50 green. for green skip
%first frame

fivename = 'D:\Data\Simon\LivemRNA\Data\RawDynamicsData\2017-04-26\MAX_P2P-MS2-LacZ-PP7_10sec_800Hz.lif - C=1 red.tif';
info = imfinfo(fivename);
num_images = numel(info);
for k = 1:num_images
    Image = imread(fivename, k, 'Info', info);
    ImThresh=Image>gThreshold;
    ImLabel=bwlabel(ImThresh);
    NSpots5(k)=max(max(ImLabel));
end
threename = 'D:\Data\Simon\LivemRNA\Data\RawDynamicsData\2017-04-26\MAX_P2P-MS2-LacZ-PP7_10sec_800Hz.lif - C=0 green.tif';
info = imfinfo(threename);
num_images = numel(info);
for k = 1:num_images %starts at 2 because i didn't like first image in the time series
    Image = imread(threename, k, 'Info', info);
    ImThresh=Image>rThreshold;
    ImLabel=bwlabel(ImThresh);
    NSpots3(k)=max(max(ImLabel));
end
figure(3)
Time5=(1:num_images)*20;        %In seconds
plot(Time5,NSpots5,'-g')
xlabel('Time (s)')
ylabel('Nspots')
Time3=(1:num_images)*20;        %In seconds
hold on
plot(Time3,NSpots3,'-r')
hold off
legend('3','5')
xlim([100,2000])


