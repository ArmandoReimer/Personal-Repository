function ci = getCI(y)

n = length(y);

ybar = mean(y);
se = std(y)/sqrt(n);
nu = n - 1;

conf = 0.95;
alpha = 1 - conf;
pLo = alpha/2;
pUp = 1 - alpha/2;


crit = tinv([pLo pUp], nu);

ci = ybar + crit*se;

end

