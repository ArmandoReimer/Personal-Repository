function write_matrix_bin( filename, matrix, varargin )
%WRITE_MATRIX_BIN write_matrix_bin(f,m) saves the matrix "m" in a binary 
% file "f". write_matrix_bin is a lot fast than the built in save(), and 
% takes up much less diskspace than "save -v6 which doesn't use compression.
%
% write_matrix_bin also includes an option for compression with dzip 
% (http://www.mathworks.com/matlabcentral/fileexchange/8899). However, this 
% is only for convinience, and not because it's superior than the built in save()
%
% Limitations: Think before you use write_matrix_bin() instead of save().
%  * Since write_matrix_bin() as default saves values as float32 it will approximate your data.
%  * you can't save a large matrix with compression turned on. java will urn of out heap space. This is a problem with dzip.
%
% Here's a real life example (8000000 bytes = 7.6MB):
%
% >> whos data_matrix
%  Name               Size                   Bytes  Class     Attributes
%
%  data_matrix      100x100x100            8000000  double              
%
%
% %% Writing data to the disk
%
% write_matrix_bin('write.compressed.test', data_matrix, 'compress', 1) => 0.509179 seconds. Filesize: 884K
% save('write.save.test', 'data_matrix')                                => 0.582949 seconds. Filesize: 996K
% write_matrix_bin('write.uncompressed.test', data_matrix)              => 0.082440 seconds. Filesize: 3.9M
% save -v6 'write.savev6.test' 'data_matrix'                            => 0.292839 seconds. Filesize: 7.7M
%
% %% Reading data from the disk
%
% read_matrix_bin('write.compressed.test', 'compress', 1)               => 0.349878 seconds.
% read_matrix_bin('write.uncompressed.test')                            => 0.103816 seconds.
% load('write.save.test') % the compressed file                         => 0.088620 seconds.
% load('write.savev6.test') % the uncompressed file                     => 0.061182 seconds.

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


one_d_matrix = reshape(matrix, 1, length(matrix(:)));
matrix_size = size(matrix);
dimensions = size(matrix_size,2);
matrix = cat(2, dimensions, matrix_size, one_d_matrix);

if compress
    format = 'uint8';
    matrix = dzip(matrix);
end

fid = fopen(filename, 'wb');
fwrite(fid, matrix, format);
fclose(fid); 

end

