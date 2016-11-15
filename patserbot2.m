function patser(matrix, sequence)
    system(['patser-v3e.exe',' -m ',matrix,' -f ',sequence,' -A "a:t 3 c:g 2"', '>out.txt']); %run executable with content of fname as inputs
    f = fileread('out.txt');
    fid = fopen('out.txt', 'wt');
    fprintf(fid, '\n%s', 'TF_whaeer', f);
    fclose(fid);
    fileread('out.txt')
    graph_patser_results('out.txt');
    fclose('all');
end