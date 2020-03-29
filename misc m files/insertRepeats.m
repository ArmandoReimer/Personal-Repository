function insertRepeats(in_path, out_path,repeat,spacer_length)

%Adds repeat string to a given sequence every spacer_length number of
%bases. Reads and writes to text files specified by in_path and out_path.

disp('Adding repeat elements...')
tic;

fin = fopen(in_path);
input_sequence = textscan(fin,'%s');
fclose(fin);
output_sequence = input_sequence{1}{1} %#ok<NOPRT>
i=1;
j=1;
k=0;
while j < length(input_sequence{1}{1})
    if mod(i,spacer_length) == 0
        k = k+1;
        output_sequence = [output_sequence( 1:length(repeat)*k+(j-1) ),repeat,...
            output_sequence( length(repeat)*k+j :end)];
        i = i-8;
    end
    i = i+1;
    j = j+1;
end

fout = fopen(out_path,'w');
fprintf(fout,'%s',output_sequence);
fclose(fout);

disp('Done.')
toc;
        
