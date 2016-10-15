%This data comes from 
%http://kirschner.med.harvard.edu/files/bionumbers/The%20Number%20of%20Molecules%20of%20Endogenous%20Transcription%20Factors%20per%20Cell%20or%20Nucleus%20in%20Drosophila,%20mouse%20or%20rat%20and%20human.pdf

accessible_motifs = 1E4;

fly = struct();
fly.TF = ['Bcd', 'Eve', 'Ftz', 'GAG', 'Grainyhead', 'HSTF', 'Zelda'];
fly.CopyNumber = [2E4, 5E4, 5E4, 1E6, 1.5E5, 3.2E4, 2.5E5];
fly.Motifs = ones(size(fly.CopyNumber))*accessible_motifs;
fly.CNtoMotifRatio = fly.CopyNumber ./ fly.Motifs;

rodent = struct();
rodent.TF = ['AHR', 'AR', 'ARNT', 'C/EBPB', 'CREB', 'E2A', 'GR',...
    'Ikaros', 'NF-kB p65', 'TR'];
rodent.CopyNumber = [1.2E4, 3.2E5, 2.3E4, 2.6E4, 3.3E4,...
    2.5E5, 2.5E7, 4E4, 3E4, 1.3E4, 2.5E5, 2.5E5, 4E3];
rodent.Motifs = ones(size(rodent.CopyNumber))*accessible_motifs;
rodent.CNtoMotifRatio = rodent.CopyNumber ./ rodent.Motifs;

human = struct();
human.TF = ['AP-2a', 'ER', 'fos', 'GR', 'myc', 'MyoD', 'NF-kB p65',...
    'p53', 'PR', 'P-Smad2', 'STAT2', 'STAT6', 'Tcf-1'];
human.CopyNumber = [2E5, 1.1E4, 2.6E5, 4E3, 1E5, 6E4, 1.4E5,...
    5E4, 1.2E5, 2.1E4, 1.6E5, 2E5, 2E4, 1.5E5, 1E4, 2E5, 2.9E6];
human.Motifs = ones(size(human.CopyNumber))*accessible_motifs;
human.CNtoMotifRatio = human.CopyNumber ./ human.Motifs;

eukaryotes = struct();
eukaryotes.CopyNumber = [fly.CopyNumber, rodent.CopyNumber, human.CopyNumber];
eukaryotes.Motifs = ones(size(eukaryotes.CopyNumber))*accessible_motifs;
eukaryotes.CNtoMotifRatio = eukaryotes.CopyNumber ./ eukaryotes.Motifs;

figure(1)
hist(log10(eukaryotes.CopyNumber))
xlabel('log_{10} transcription factor copy number')
ylabel('Counts')

figure(2)
hist(log10(eukaryotes.CNtoMotifRatio))
xlabel('log_{10} Copy Number to Binding Site Ratio')
ylabel('Counts')
