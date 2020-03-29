function plotFromCombinedEmbryo()

figure;

    
%     apdiv = data(dataSet).APDivision; 
%     if adiv(nc, :) ~= 0
%     end
    
load('E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2\mcp_opt_combinedEmbryo\mcp_opt_Combined_APDivision.mat')
load('E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2\mcp_opt_combinedEmbryo\mcp_opt_Combined_CompiledParticles.mat')

doStuff(APDivision, MeanVectorAP)

load('E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2\0A3v7lacZ_combinedEmbryo\0A3v7lacZ_Combined_APDivision.mat')
load('E:\Armando\LivemRNA\Data\Dropbox\SyntheticEnhancersMS2\0A3v7lacZ_combinedEmbryo\0A3v7lacZ_Combined_CompiledParticles.mat')

doStuff(APDivision, MeanVectorAP)

   
legend('1A3', '0A3')
        standardizeFigure(gca, []);


end

function doStuff(APDivision, MeanVectorAP)
        nc = 12;
        nBins = 41;
        meanTotalIntensity = nan(1, nBins);
        apRes = .025;

        for apbin = 1:nBins
            if APDivision(nc, apbin) ~= 0
                meanTotalIntensity(apbin) = nansum(MeanVectorAP(APDivision(nc, apbin):APDivision(nc+1, apbin),apbin));
            else
                meanTotalIntensity(apbin) = NaN;
            end
        end
        ax = gca;
        % figure
        hold(ax, 'on')
        plot(ax,(1:nBins)*apRes, meanTotalIntensity);
        title(ax,'average accumulated intensity over NC 12');
        ylabel('time-integrated average intensity (au)');
        xlabel('AP')
    end