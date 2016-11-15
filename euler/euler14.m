chainlengths = zeros(1, 1E6);
for i = 1:1E6
    n = i;
    while n>1
        if ~mod(n,2)
            n = n/2;
        else
            n = 3*n+1;
        end
        chainlengths(i) = chainlengths(i)+1;
    end
end
[ans, ind] = max(chainlengths)