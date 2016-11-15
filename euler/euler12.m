seqlength = 1E5;
num_factors = 2*ones(1, seqlength);
for n = 1:seqlength
    tri = (1/2)*n*(n+1);
    for j = 2:ceil(tri/2)
        if ~mod(tri, j)
            num_factors(n) = num_factors(n) + 1;
        end
    end
    if num_factors(n) > 500
        display(tri)
        break;
    end
end