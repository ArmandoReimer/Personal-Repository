goods = [];
parfor i = 1:100000000
    s = num2str(i);
    fsum = 0;
    for j = 1:length(s)
        fsum = fsum + factorial(str2num(s(j)));
    end
    if i == fsum
        goods = [goods, i];
    end
end
goods
sum(goods)
    
    