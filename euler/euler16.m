f = sym(2^1000)
s = char(f)
sum = 0;
for j = 1:length(s)
    sum = sum + str2num(s(j));
end
sum
