load('D:\Data\Armando\livemRNA\Data\Dropbox\DynamicsResults\2017-09-25-HisBFP_PCPmCherry\CompiledNuclei.mat')
plot(ElapsedTime, MeanVectorAll)
xlabel('Time since imaging started (min)')
ylabel('Average nuclear fluorescence in the red channel (A.U.)')
title(Prefix)
hold on
nc13 = ElapsedTime(14);
nc14 = ElapsedTime(38);
y1=get(gca,'ylim');
plot([nc13, nc13], y1);
hold on
 plot([nc14, nc14], y1)
l = legend('Fluorescence intensity', 'nc13','nc14');
standardizeFigure(gca,l);

