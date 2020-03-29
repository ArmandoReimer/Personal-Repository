profile off
profile on
prefix = '2019-05-24-0A3v7lacZ_18';

fig = figure;
ax = axes(figure);
nWorkers = 5:10;
t = 1:length(nWorkers);

for i = nWorkers
    tic
    startParallelPool(i,0,0)
    TrackNuclei(prefix, 'NoBulkShift','ExpandedSpaceTolerance', 1.5 )
    t(i) = toc;
    plot(ax,nWorkers(1:i), t(1:i));
    drawnow;
    hold on
end