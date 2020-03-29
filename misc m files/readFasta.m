function readFasta(in_path, out_path)

%Takes a fasta file and removes all non-sequence information.

disp('Simplifying data...')
tic;

fin = fopen(in_path);
input_sequence = textscan(fin,'%s');
fclose(fin);
output_sequence = {}; 

for i=1:length(input_sequence{1})
    line = char(input_sequence{1}(i));
    if isempty(~strfind(line,'>'))
        output_sequence{floor(i/2)} = line; %#ok<AGROW>
    end   
end

fout = fopen(out_path,'w');
for j=1:length(output_sequence)
        fprintf(fout,'%s\r\n', output_sequence{j});
end
fclose(fout);

disp('Done.')
toc;

        