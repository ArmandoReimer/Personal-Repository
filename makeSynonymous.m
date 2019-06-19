function outDNASeq = makeSynonymous(inSeq, forbidden, writePath)

%author: armando reimer areimer@berkeley.edu

%inSeq is a character array of one-letter amino acids to be translated.
%e.g. inSeq = 'FGTA...'

%forbidden is a 1D cell array of strings that should not be allowed in the
%final construct. e.g. don't include digest sites necessary for cloning. 5'
%splice junctions are appended to this list automatically. 

dmelfiveprimesplice = {'AAGGTAAGT','AAGGTGAGT','CAGGTAAGT','CAGGTGAGT'}; 
%try not to introduce new introns. 5' is easier to deal with than 3' splice junction
%other splice sites to consider are the branch consensus and polypyrimidine
%tracts. for now, just looking at 5' junction seems sufficient. CTAAT is
%the branchpoint consensus and it has distance requirements from the splice
%junctions. 

forbidden = [forbidden, dmelfiveprimesplice];

%%
%validate input sequence
if mod(length(inSeq), 3) ~= 0
    error('bad input sequence.')
end

%%
codonTable = load('E:\Armando\Personal-Repository\codonTable.mat');
codonTable = codonTable.codonTable;

outDNASeq = '';
outProteinSeq = '';

for a = 1:length(inSeq)
    
    codonIndex = find(contains(codonTable(1, :), inSeq(a)));
    codons = codonTable{2, codonIndex};
    codonFreqs = codonTable{3, codonIndex};
    
    codon = pickCodon(codons, codonFreqs);
    
    
    outDNASeq = [outDNASeq, codon];
    outProteinSeq = [outProteinSeq, codonTable{1, codonIndex}];
    
end

%%
%make sure no forbidden patterns were introduced

if contains(outDNASeq, forbidden)
    %try again
    outDNASeq = makeSynonymous(inSeq, forbidden, writePath);
else
    %this is fine. keep going. 
end


%%
%validate the protein sequence wasn't changed.
if ~isequal(outProteinSeq, inSeq)
    error('bad output sequence.')
end

%validate length of output DNA sequence
if ~isequal(length(inSeq)*3, length(outDNASeq))
    error('bad output sequence');
end
%%
%validate %GC
tolerance = .1; %i made this number up. AR
okGC = .5; %i made this up too.
bounds = [okGC - tolerance, okGC + tolerance];

GCfreq = sum(outDNASeq == 'G' | outDNASeq == 'C') / length(outDNASeq);

if GCfreq < bounds(1) | GCfreq > bounds(2)
    disp('GC content weird. Trying again.')
    outDNASeq = makeSynonymous(inSeq, forbidden, writePath);
end

%%
%check how repetitive the sequence is
file = [writePath, filesep, 'outDNASeq.txt'];
fid=fopen(file,'w');
fprintf(fid, '%c', '>s');
fprintf(fid, '%c\r\n', '');
fprintf(fid, '%c', outDNASeq);
[~, ~] = system(['cd ', writePath, ' & ', 'trf409.dos64.exe ', file, ' 2 7 7 80 10 50 500 -f -d -m -h']);
fmaskid = fopen([file, '.2.7.7.80.10.50.500.mask'], 'r');
mask = fscanf(fmaskid, '%c');
mask = mask(3:end);
if contains(mask, 'N')
    outDNASeq = makeSynonymous(inSeq, forbidden, writePath);
end
    
%%
disp('It''s recommended to check this sequence against 1. tandem repeat finder (https://tandem.bu.edu/trf/trf.html) , 2. BDGP splice site prediction neural network.')

end

function codon = pickCodon(codons, codonFreqs)

%introduces some adherence to the drosophila codon usage table by
%mostly avoiding rare codons

randomCodonIndex = randi(length(codons));
codonFreq = codonFreqs(randomCodonIndex);
if codonFreq <= .1
    maybeUse = rand;
    if maybeUse < .5 %only use the rare codon half the time 
        %try again
        tempCodon = pickCodon(codons, codonFreqs);
    else
        tempCodon = codons{randomCodonIndex};
    end
else
    tempCodon = codons{randomCodonIndex};
end

codon = tempCodon;

end