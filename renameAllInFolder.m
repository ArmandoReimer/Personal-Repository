folder = 'E:\DorsalSynthetics\Data\ProcessedData\2020-02-14-1Dg11_EfEfEf_28_\dogs\'
a = dir([folder, '*.mat'])

for i = 1:length(a)
    
    oldname = a(i).name;
    oldpath = [folder, oldname];
    
    newname = strrep(oldname, '.tif.mat', '.mat');
    newpath = [folder, newname];

    movefile(oldpath, newpath)
    
end