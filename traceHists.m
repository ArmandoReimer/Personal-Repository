function traceHists(Prefix)
    % n = 6;
    % for i = 1:n
    %     CompileParticles(['2018-07-12-1A3v7L16_td_opt_',num2str(i)], 'ApproveAll')
    % end

%     first = load('E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2\2018-07-12-1A3v7L16_td_opt_3\CompiledParticles.mat');
    first = load(['E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2\',Prefix,'\CompiledParticles.mat']);
    % second = load('E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2\2017-07-12-1A3+5_MS2v7L16_12\CompiledParticles.mat');
    firstCP = first.CompiledParticles;
    area = 437;
    fluo = [];
    offset = [];
    for i = 1:length(firstCP)
        for j = 1:length(firstCP(i).Frame)
            off = firstCP(i).Off(j)*area;
            offset = [offset, off];
            fluo = [fluo, firstCP(i).Fluo(j) + off];
        end
    end
    nBins = 20;
    histogram(offset,nBins,'Normalization','probability', 'facealpha', .8);
    standardizeFigure(gca, [], 'red', 'fontSize', 14);
    hold on
    histogram(fluo,nBins,'Normalization','probability', 'facealpha', .8);
    standardizeFigure(gca, [], 'cyan', 'fontSize', 14);
    legend('background', 'spots')

%     histogram(fluo./offset,nBins,'Normalization','probability', 'facealpha', .8);
%     standardizeFigure(gca, [], 'red', 'fontSize', 14);
end