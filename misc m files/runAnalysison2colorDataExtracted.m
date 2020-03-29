% function runAnalysison2colorDataExtracted(Prefix3, Prefix5)
% function runAnalysison2colorDataExtracted(Prefix3, Prefix5)
%
% DESCRIPTION
% Isolate spots from different channels in 2 color experiments to compare
% green and red time traces.
%
% ARGUMENTS
% Prefixes for the elongation data (one prefix per channel)
%
% OPTIONS
% None.
%               
% OUTPUT
% Plots.
%
% Author (contact): Armando Reimer (areimer@berkeley.edu)
% Created: 6/27/17
% Last Updated: 8/31/2017
%
% Documented by: Armando Reimer (areimer@berkeley.edu)

[SourcePath,FISHPath,DefaultDropboxFolder,MS2CodePath,PreProcPath]=...
    DetermineLocalFolders;

Prefix3 = Prefix10sc1;
Prefix5 = Prefix10sc2;

path5 = [DefaultDropboxFolder, filesep,Prefix5, filesep];
path3 = [DefaultDropboxFolder, filesep,Prefix3, filesep];
mcp5frameinfo = load([path5, 'FrameInfo.mat']);
mcp5frameinfo = mcp5frameinfo.FrameInfo;
dt = mcp5frameinfo(2).Time;

%exppath = 'C:\Users\ArmandoReimer\Documents\Personal-Repository\Teaching\physio2017';
data3 = open([DefaultDropboxFolder,filesep,Prefix3,filesep,'extract3.mat']);
data5 = open([DefaultDropboxFolder,filesep,Prefix5,filesep,'extract5.mat']);
s3 = data3.s3;
s5 = data5.s5;



%%%%
%Make calibration curve.
greenvals = [];
redvals = [];
greenvalss = [];
redvalss = [];
 % how many pixels we want to calculate the fluorescence?
        BrightestPixels = 10;

for k = 1:length(s3)
    if length(s3(k).Frame) > 15
        a = s3(k).SnippetGreen;
        b = s3(k).SnippetRed;
        aim = s3(k).mask3;
        bim = s3(k).mask5;
        greensum = [];
        redsum = [];
        greenmax = [];
        redmax = [];
       
       % \/\/\/\/\*** apply the calibration here ***\/\/\/\/\
        % Intercept = A
        % Slope = B
        % Spot5Image = (SpotImage + Intercept)*Slope;
% 
%        % get the mean intensity of the brightest pixels
%         Sorted3Image = sort(a(:),'descend');
%         Max3Intensity = sum(b(1:BrightestPixels));
%         Sorted5Image = sort(a(:),'descend');
%         Max5Intensity = sum(b(1:BrightestPixels));
% 
%        %Store the traces
%         Trace3(frame) = Max3Intensity;
%         Trace5(frame) = Max5Intensity;

        for i = 1:length(a)
            a{i} = a{i} - min(a{i});
            b{i} = b{i} - min(b{i});
            Sorted3Image = sort(a{i}(:),'descend');
            Max3Intensity = sum(Sorted3Image(1:BrightestPixels));
            Sorted5Image = sort(b{i}(:),'descend');
            Max5Intensity = sum(Sorted5Image(1:BrightestPixels));
            greenvalss = [greenvalss, sum(Sorted3Image(1:BrightestPixels))];
            greenvals = [greenvals, max(max(a{i}))];
            redvalss = [redvalss,sum(Sorted5Image(1:BrightestPixels))];
            redvals = [redvals,max(max(b{i}))];
        end
    end
end

% redvals = sort(redvals);
% greenvals = sort(greenvals);

for o = 1:length(greenvalss)
    if greenvalss(o) < 200
        greenvalss(o) = NaN;
        redvalss(o) = NaN;
    end
end
greenvalss = greenvalss(~isnan(greenvalss));
redvalss = redvalss(~isnan(redvalss));
% 
% figure(1)
% scatter(redvals, greenvals)
% xlabel('red')
% ylabel('green')
% title('calibration curve (all points from long traces). max')
% figure(2)
% % redvalss = sort(redvalss, 'ascend');
% % redvalss = redvalss(170:end);
% % greenvalss = sort(greenvalss, 'ascend');
% % greenvalss = greenvalss(170:end);
% scatter(redvalss, greenvalss)
% xlabel('red')
% ylabel('green')
% title('calibration curve (all points from long traces). sum')
% hold on
% xlim([0, max([redvalss,greenvalss])])
% ylim([-200, nanmax([redvalss,greenvalss])])
% p = polyfit(redvalss,greenvalss, 1);
% y1 = polyval(p, redvalss);
% plot(redvalss, y1);
% hold off


%%%%

% dataElon = open([exppath, '\20sSnippetStructures.mat']);
% s3 = dataElon.s3;
% s5 = dataElon.s5;


gaps = [];
n = 0;
eTime = [];
allCellMovies10s = {};
for k = 1:length(s3)
    if length(s3(k).newFrames) > 15
        n = n + 1;
        display(n)
        a = s3(k).SnippetGreen;
        b = s3(k).SnippetRed;
        t = s3(k).newFrames;
        aim = s3(k).mask3;
        bim = s3(k).mask5;
        allCellMovies10s = [allCellMovies10s,{aim; bim}];
        greensum = [];
        rawredsum = [];
        greenmax = [];
        rawredmax = [];
        greenvals = [];
        redvals = [];
        greenvalss = [];
        redvalss = [];
        for i = 1:length(a)
            a{i} = a{i} - min(a{i});
            b{i} = b{i} - min(b{i});
            Sorted3Image = sort(a{i}(:),'descend');
            Max3Intensity = sum(Sorted3Image(1:BrightestPixels));
            Sorted5Image = sort(a{i}(:),'descend');
            Max5Intensity = sum(Sorted5Image(1:BrightestPixels));
            greenvalss = [greenvalss, sum(Sorted3Image(1:BrightestPixels))];
            greenvals = [greenvals, max(max(a{i}))];
            redvalss = [redvalss,sum(Sorted5Image(1:BrightestPixels))];
            redvals = [redvals,max(max(b{i}))];
        end
%         
%         fivePrimeFrames = b;
%         threePrimeFrames = a;
%         
        
        %do the calibration
        
        redsum = rawredsum;
        redmax = rawredmax;
        %redsum = (3.*rawredsum) - 4500;
        %redmax = 3.*rawredmax - 50;      
%         
%         maxmaxred = max(redmax);
%         minmaxred = min(redmax);
%         maxmaxgreen = max(greenmax);
%         minmaxgreen = min(greenmax);
%         
%         maxred50 = maxmaxred-minmaxred;
%         maxgreen50 = maxmaxgreen - minmaxgreen;
%         [c indexmaxred] = min(abs(redmax-maxred50));
%         
%         
%         maxgap = ;
%         sumgap = 0;

%         figure(3)
%         plot(t, greenvalss, 'g')
%         hold on
%         plot(t, redvalss, 'r');
%         title(['Sum trace:', num2str(k)]);
%         legend('3''', '5''')
%         hold off
%         
%         figure(4)
%         plot(t, greenvals, 'g')
%         hold on
%         plot(t, redvals, 'r');
%         title(['Max trace:', k]);
%         legend('3''', '5''')
%       %  xlim([0, 
%         hold off
        
%         
%         %%%%Do a cross-correlation?
%         
%         [ccor, lag] = xcorr(rawredsum, greenmax);
%         %smooth it in preparation for two derivatives. probably pchip
%         %but will compare spline too
%         oversamplingrate = 1/10;
%         xq1 = lag(1):oversamplingrate:lag(end);
%         p = pchip(lag,ccor,xq1);
%         p = smooth(p, 75);
%         figure(5)
%         plot(xq1, p);
%         title('Cross-correlation of red (cal.) and green max values');
%         xlabel('Lag time (frames)')
%         ylabel('Cross-correlation')
%         hold on
%         plot(lag, ccor, 'rx');
%         legend('pchip, 10x sample', 'raw data')
%         hold off
%         
%         figure(6)
%         dc = diff(p);
%         dxq1 = (xq1(1)+(oversamplingrate/2)):oversamplingrate:(xq1(end)-(oversamplingrate/2)); %we lost 1 sample with the derivative. 
%         %this now samples in between the previous timepoints.
%         plot(dxq1, dc, 'rx')
%         title('First derivative of smoothed correlation')
%         hold on
%         plot(dxq1, smooth(dc, 75))
%         hold off
%         
%         figure(7)
%         ddc = diff(dc);
%         ddxq1 = dt/60*(xq1(1)+oversamplingrate:oversamplingrate:xq1(end)-oversamplingrate); %we lost 1 sample with the derivative. 
%         plot(ddxq1, ddc, 'rx')
%         title('Second derivative of smoothed correlation')
%         hold on
%         ddc = smooth(ddc, 50);
%         plot(ddxq1, ddc)
%         xlabel('Time lag (min)')
%         [m, i] = max(ddc);
%         scatter(ddxq1(i), m, 'k', 'linewidth', 1);
%         text(ddxq1(i), m, [num2str(ddxq1(i)), ' mins'],'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left')
%         hold off
%         
%         elt = ddxq1(i);
%         genelength = 1.4 + 3; 
%         elr = elt / genelength; %kbs/min
% 
%         %%%%
%         newgap = 0;
%         gaps = [gaps, newgap];
        save('D:\Data\Armando\dataAnalysis\allCellMovies10s.mat', 'allCellMovies10s');
    end
end


