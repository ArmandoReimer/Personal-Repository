function [ matrix ] = read_matrix_bin( filename, varargin )
%READ_MATRIX_BIN Reads a binary file which was saved by write_matrix_bin()

compress = 0;
format = 'float32';

for ind = 1:2:length(varargin)
    name = varargin{ind};
    value = varargin{ind+1};
    
    switch name
        
        case 'compress'
            compress = value;
            
        case 'format'
            format = value;
    end
end

if compress
    format = 'uint8';
end


fid = fopen(filename, 'r');
try
    matrix = fread(fid, format);
catch
    error(['Could not read: ' filename '. The file may not exist.']);
end

fclose(fid);

if compress
    matrix = dunzip(matrix)';
end


dim = matrix(1); % find the dimension of the matrix
original_size = matrix(2:dim+1)'; % knowing the dimension we can extract the size
matrix = matrix(dim+2:end); % strip the metadata from the matrix

matrix = reshape(matrix,original_size);

end

