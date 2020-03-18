dataTypes = { '1Dg_2xDl', '1Dg-8D_FFF',...
    '1DgW_2x_Leica', '1DgW_FFF', '1Dg11_FFF',...
    '1Dg-5_FFF', '1DgVW_FFF', '1Dg_og'};

%2xDl and 1dg-8 are done. 

for k = 1:length(dataTypes)
    
    [~, ~, prefixes] = getDorsalPrefixes(dataTypes{k});
     
    for i = 1:length(prefixes)
        makeHisMatFromMovieMat(prefixes{i});
    end
    
end