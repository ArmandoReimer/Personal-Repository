
[~,Prefixes] = LoadMS2Sets('mcp_opt');
for i = 1:length(Prefixes)
    CompileParticles(Prefixes{i}, 'ApproveAll','intArea', 437, 'MinParticles', 0, 'SkipAll', 'doSingleFits')
end
