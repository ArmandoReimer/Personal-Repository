concentrations = [5.47, 20.68, 65.49];
mRNA = [111.8355, 260.4466, 377.31705];
plot(concentrations, mRNA, '.')
ylabel('mRNA (peak nc12 mean spot intensity in A. U.')
xlabel('concentration (A.U.)')
title('tdMCPGFP binding curve')
standardizeFigure(gca, [])