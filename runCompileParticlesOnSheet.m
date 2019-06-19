function runCompileParticlesOnSheet(varargin)

    %run compile particles on sheets of the data status file 
    
    for j = 1:length(varargin)
        
        [~, prefixCell] = LoadMS2Sets(varargin{j});
     
        for i = 1:length(prefixCell)
             prefix = prefixCell{i};
             disp(prefix);
             disp(num2str(i));
%              fit3DGaussiansToAllSpots(prefix);
             CompileParticles(prefix, 'SkipAll','ApproveAll', 'MinTime', 0, 'MinParticles', 1, 'minBinSize', .3, 'intArea', 270)
        end
        
    end
    
end
