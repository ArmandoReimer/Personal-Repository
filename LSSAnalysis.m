Dir = dir('E:\Data\Armando\Data\RawDynamicsData\2016-02-17\movie 2- bandpass1\tifs');
im_stack = {};
for j = 1:length(Dir)
    if strfind(Dir(j).name, '.tif')
        %Load tif z-stack into a cell array. This must be repeated for each
        %timepoint.
        fname = ['E:\Data\Armando\Data\RawDynamicsData\2016-02-17\movie 2- bandpass1\tifs\',Dir(j).name];
        info = imfinfo(fname);
        num_images = numel(info);
        for i = 1:num_images
            im_stack{j, i} = imread(fname, i, 'Info', info);
        end
    end
end

im_stack(1, :) = [];
im_stack(1, :) = [];

