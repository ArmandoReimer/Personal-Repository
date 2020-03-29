files = dir;
files = files(3:end);
responses = zeros(1, numel(files));
for i = 1:numel(files)
    filename = files(i).name;
    lif = bfopen(filename);
    im = lif{1}{1};
    responses(i) = median(reshape(im,[1,numel(im)]));
end
sorted = sort(responses);
plot(.1:.1:4, sorted, '.-k')