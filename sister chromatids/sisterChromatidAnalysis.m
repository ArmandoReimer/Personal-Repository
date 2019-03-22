load 'E:\Armando\LivemRNA\Data\Dropbox\DynamicsResults\2015-05-31-89B8-3-P2P\Spots.mat'
load 'E:\Armando\LivemRNA\Data\Dropbox\DynamicsResults\2015-05-31-89B8-3-P2P\FrameInfo.mat'
distancelist = [];
amplist = [];
framesdup = [];
for i = 1:length(Spots)
    for j = 1:length(Spots(i).Fits)
        for k = 1:length(Spots(i).Fits(j).z)
            distance = Spots(i).Fits(j).sisterSeparation2{k};
            framesdup = [framesdup,Spots(i).Fits(j).frame];
            if ~isempty(distance)
                distancelist = [distancelist, distance];
                amplist = [amplist, mean(Spots(i).Fits(j).sisterAmps{k})];
%                 figure(1)
%                 imshow(imresize(Spots(i).Fits(j).Snippet{k},10),[])    
%                 figure(2)
%                 imshow(Spots(i).Fits(j).Snippet{k},'InitialMagnification',6400, 'DisplayRange', [])
%                 10001
            else 
                distancelist = [distancelist, 0];
                amplist = [amplist, Spots(i).Fits(j).CentralIntensity];
            end
        end
    end
end

distancesum = zeros(1,length(FrameInfo));
ampsum = zeros(1,length(FrameInfo));
time = (1:length(FrameInfo)).*FrameInfo(2).Time;
nspots = zeros(1,length(FrameInfo));
for i = 1:length(FrameInfo)
    for j = 1:length(framesdup)
        if framesdup(j) == i
            distancesum(i) = distancesum(i) + distancelist(j);
            ampsum(i) = ampsum(i) + amplist(j);
            nspots(i) = nspots(i)+1;
        end
    end
end

figure(1)
plot(time, distancesum./nspots)
xlabel('Time (min)')
ylabel('Peak-to-peak sister separation (pixels)')
standardizeFigure;
figure(2)
scatter((framesdup.*FrameInfo(2).Time)/60,distancelist)
xlabel('Time (min)')
ylabel('Average peak-to-peak sister separation (pixels)')
standardizeFigure;
figure(3)
scatter(distancesum./nspots, ampsum./nspots);
xlabel('Average peak-to-peak sister separation (pixels)')
ylabel('Average sister amplitude (A.U.)')
standardizeFigure;