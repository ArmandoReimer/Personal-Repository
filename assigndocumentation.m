d = dir;
ix = randperm(length(dir));
documents = d(ix);
documenter_assignments = {};
documenters = {'armando', 'liz', 'alex', 'simon', 'yang joon', 'myron',...
    'meghan', 'nick', 'gabriella', 'emma', 'augusto'};
for j = 1:length(documenters)
    documenter_assignments{j} = [];
end
for i = 1:length(documents)
    iy =  mod(i, length(documenters)) + 1
    documenter_assignments{iy} = [documenter_assignments{iy}, documents(i)];
end
documenter_assignments   