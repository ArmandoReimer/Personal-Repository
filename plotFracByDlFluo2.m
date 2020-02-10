function plotFracByDlFluo2(DataType, varargin)

fractionFlag = false;
mrnaFlag = false;
durationFlag =false;
maxFlag =false;
turnOnFlag = false;


displayTiles = false;

minNuclei =1; %minimum total nuclei for a bin to be plottable
minEmbryos = 1; %minimum number of nuclei per bin

for i = 1:length(varargin)
    if strcmpi(varargin{i}, 'fraction')
        fractionFlag = true;
    elseif strcmpi(varargin{i}, 'mrna')
        mrnaFlag = true;
    elseif strcmpi(varargin{i}, 'duration')
        durationFlag = true;
    elseif strcmpi(varargin{i}, 'maxfluo') || strcmpi(varargin{i}, 'max')
        maxFlag = true;
    elseif strcmpi(varargin{i}, 'turnOn') || strcmpi(varargin{i}, 'timeOn')
        turnOnFlag = true;
    elseif strcmpi(varargin{i}, 'displayTiles')
        displayTiles = true;
        tileFig = figure();
        holdFig = figure();
    end
end

[~, resultsFolder, prefixes] = getDorsalPrefixes(DataType);

load([resultsFolder,filesep,DataType,filesep,'dlfluobins.mat'], 'dlfluobins');

ch = 1;
nEmbryos = length(prefixes);
nBins = length(dlfluobins);

binFilter =  {ones(1, nBins), ones(1, nBins), ones(1, nBins)};
embryosPerBin = {zeros(1, nBins), zeros(1, nBins), zeros(1, nBins)};
allmrnasnomean = cell(3, nBins);

npartFluoEmbryo = {};
nschnitzFluoEmbryo = {};
fracFluoEmbryo = {};

compiledProjects = {};
for e = 1:nEmbryos
    
    load([resultsFolder,filesep,prefixes{e},filesep,'compiledProject.mat'], 'compiledProject');
    
    compiledProjects{e} = compiledProject;
    
    for nc = 12:14
        for bin = 1:nBins
            
            tempNucleiOfInterest = [];
            spotAccumulatedFluo = [];
            spotDurations = [];
            spotMaxFluos = [];
            spotTurnOnTimes = [];
            
            nucleiOfInterest= find( [compiledProject.cycle] == nc & [compiledProject.dorsalFluoBin] == bin );
            
            particlesOfInterest = 0;
            for n = 1:length(nucleiOfInterest)
                
                cn = compiledProject(nucleiOfInterest(n));
                
                tempNucleiOfInterest = [tempNucleiOfInterest, nucleiOfInterest(n)];
                
                if ~isempty(cn.particleFrames)
                    particlesOfInterest = particlesOfInterest + 1;
                    spotFrames = cn.particleFrames;
                    spotFluo = cn.particleFluo3D; %can also use .Fluo for 2d fluo
                    spotDurations = [spotDurations, cn.particleDuration];
                    spotTurnOnTimes = [spotTurnOnTimes, cn.particleTimeOn];
                    spotMaxFluos = [spotMaxFluos, cn.particleFluo95];
                    spotAccumulatedFluo = [spotAccumulatedFluo, cn.particleAccumulatedFluo];
                end
                
                %                 figure(holdFig)
                %                 yyaxis left
                %                 plot(cn.nuclearFrames, cn.FluoTimeTrace, '-g');
                %                 ylim([0, max(dlfluobins)]);
                %                 yyaxis right
                %                 plot(spotFrames, spotFluo, '.-r'); %spot intensity
                %                 %                         hold on
                %                 ylim([0, 1000]);
                %                 waitforbuttonpress;
                
            end
            
            
            nucleiOfInterest = tempNucleiOfInterest;
            
            allmrnasnomean{nc-11,bin} = [allmrnasnomean{nc-11,bin}, spotAccumulatedFluo];
            
            %             npartFluoEmbryo{nc-11}(bin, e) = particlesOfInterest;
            %             nschnitzFluoEmbryo{nc-11}(bin, e) = length(nucleiOfInterest);
            nschnitzFluoEmbryo{nc-11}(bin, e) = length(find( [compiledProject.cycle] == nc & [compiledProject.dorsalFluoBin] == bin ));
            npartFluoEmbryo{nc-11}(bin, e) = length(find([compiledProject.cycle] == nc & [compiledProject.dorsalFluoBin] == bin  & ~cellfun(@isempty, {compiledProject.particleFrames})));
            allmrnasEmbryo{nc-11}(bin, e) = nanmean(spotAccumulatedFluo);
            alldurationsEmbryo{nc-11}(bin, e) = nanmean(spotDurations);
            allTurnOnsEmbryo{nc-11}(bin, e) = nanmean(spotTurnOnTimes);
            allMaxFluoEmbryo{nc-11}(bin, e) = nanmean(spotMaxFluos);
            
            %             if nschnitzFluoEmbryo{nc-11}(bin, e) >= 1
            %                 embryosPerBin{nc-11}(bin) = embryosPerBin{nc-11}(bin) + 1;
            %             end
            % %
            %             if e == 2 & bin == 3 & nc == 12 %for debugging
            %                 1
            %             end
            %
        end
        
        
        fracFluoEmbryo{nc-11}(:, e) = npartFluoEmbryo{nc-11}(:,e)./nschnitzFluoEmbryo{nc-11}(:,e);
        
    end
    
end

%average across embryos
nSchnitzBinTotal = {[], []};
minNucleiFilter = {[], []};
minEmbryoFilter = {[], []};
nSchnitzBinTotalWithZeros = {[], []};
binFilter = {[], []};
nEmbryos = {[], []};
embryoDim = 2;
binDim = 1;

for nc = 1:2
    
    nSchnitzBinTotal{nc} = nansum((nschnitzFluoEmbryo{nc}), embryoDim);
    nSchnitzBinTotalWithZeros{nc} = nansum((nschnitzFluoEmbryo{nc}), embryoDim);
    nSchnitzBinTotal{nc}(~nSchnitzBinTotal{nc}) = nan; %so i can divide without getting Infs
    
    minNucleiFilter{nc} =  nSchnitzBinTotal{nc} >= minNuclei;
    minEmbryoFilter{nc} = sum(logical(nschnitzFluoEmbryo{nc}), embryoDim) >= minEmbryos;
    nEmbryos{nc} = minEmbryoFilter{nc}.*sum(logical(nschnitzFluoEmbryo{nc}), embryoDim);
    binFilter{nc} = minEmbryoFilter{nc} .* minNucleiFilter{nc};
    binFilter{nc}(~binFilter{nc}) = nan;
    
    
    
    nSamples = 100;
    
    filteredWeightedMean = @(x) ((nansum(x.*nschnitzFluoEmbryo{nc},embryoDim))./nSchnitzBinTotal{nc}).*binFilter{nc};
    filteredWeightedSE = @(y) nanstd(bootstrp(nSamples, @(x) filteredWeightedMean(x), y,'Weights',nSchnitzBinTotalWithZeros{nc})', 0, embryoDim);
    
    %     filteredWeightedMean = @(x) nanmean(x,2).*binFilter{nc}';
    %      filteredWeightedSE = @(y) nanstd(bootstrp(nSamples, @(x) filteredWeightedMean(x), y), 0, 1);
    %         filteredWeightedSE = @(x) (nanstd(x,0, 2)./sqrt(embryosPerBin{nc}'))  .* binFilter{nc}';
    
    meanFracFluoEmbryo{nc} = filteredWeightedMean(fracFluoEmbryo{nc});
    seFracFluoEmbryo{nc} = filteredWeightedSE(fracFluoEmbryo{nc});
    
    meanallmrnasEmbryo{nc} = filteredWeightedMean(allmrnasEmbryo{nc});
    seallmrnasEmbryo{nc} = filteredWeightedSE(allmrnasEmbryo{nc});
    
    meanalldurationsEmbryo{nc} = filteredWeightedMean(alldurationsEmbryo{nc});
    sealldurationsEmbryo{nc} = filteredWeightedSE(alldurationsEmbryo{nc});
    
    meanTurnOnsEmbryo{nc} = filteredWeightedMean(allTurnOnsEmbryo{nc});
    seTurnOnsEmbryo{nc} = filteredWeightedSE(allTurnOnsEmbryo{nc});
    
    meanAllMaxFluoEmbryo{nc} = filteredWeightedMean(allMaxFluoEmbryo{nc});
    seAllMaxFluoEmbryo{nc} = filteredWeightedSE(allMaxFluoEmbryo{nc});
    
end

allmrnasnc12 = allmrnasnomean(1, :);
lens = [];
for b = 1:nBins
    lens(b) = length(allmrnasnc12{b});
end
allmrnasnc12mat = zeros(nBins, max(lens));
for bin = 1:nBins
    if ~isempty(allmrnasnc12{bin})
        allmrnasnc12mat(bin, :) = padarray(allmrnasnc12{bin}',max(lens)-length(allmrnasnc12{bin}),NaN, 'post');
    end
end

%%
%plotting
for nc = 1:1
    
    if fractionFlag
        [fractionFit, fractionModel] = plotDorsalActivity(dlfluobins, fracFluoEmbryo{nc}, 'fraction competent', nc, DataType, meanFracFluoEmbryo{nc}, seFracFluoEmbryo{nc});       
    end
    if durationFlag
        [durationFit, durationModel] = plotDorsalActivity(dlfluobins,alldurationsEmbryo{nc}, 'duration active nuclei (frames)', nc, DataType, meanalldurationsEmbryo{nc}, sealldurationsEmbryo{nc});
    end
    if turnOnFlag
        [turnOnFit, turnOnModel] = plotDorsalActivity(dlfluobins, allTurnOnsEmbryo{nc}, 'turn on time (min)', nc, DataType, meanTurnOnsEmbryo{nc}, seTurnOnsEmbryo{nc});
    end
    if maxFlag
        [maxFit, maxModel] = plotDorsalActivity(dlfluobins, allMaxFluoEmbryo{nc}, '95% of brightest spots (au)', nc, DataType, meanAllMaxFluoEmbryo{nc}, seAllMaxFluoEmbryo{nc}); 
    end
    
end

end
