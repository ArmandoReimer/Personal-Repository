function [fit, model] = fitDorsalActivity(dlfluobins, activity, DataType, varargin)

fractionFlag = false;
for i = 1:length(varargin)
    if strcmpi(varargin{i},'fraction')
        fractionFlag = true;
    end
end

y = activity(:);
x = dlfluobins(:);
x(isnan(y)) = [];
y(isnan(y)) = [];

%scale the problem for better fitting
xScale =10^-(round(log10(max(x(:)))));
x = x.*xScale;
yScale = 10^-(round(log10(max(y(:)))));
y = y.*yScale;
%p(1)=rate coefficient, p(2)=kd, p(3)=hill coefficient
if ~fractionFlag
    model = @(p, x) p(1).*(... 
        ...
        ( (x)./p(2)).^p(3) ./... %numerator
        ...
         ( 1 + ((x)./p(2)).^p(3) ) ) + p(4); %partition function
else
    model = @(p, x) (... 
        ...
        ( (x)./p(1)).^p(2) ./... %numerator
        ...
         ( 1 + ((x)./p(1)).^p(2) ) ) + p(3); %partition function
end
%rate, kd, hill, y offset 
p0 = [max(y),max(x)/2, 1, 0];
lb = [0, 1500.*xScale, 2, 0];
ub = [max(y)*2, Inf, 6, 0];

%rate, kd, hill, y offset 
if contains(DataType, '1DgW', 'IgnoreCase', true)
    p0(3) = 3.5; lb(3) = 3.5; ub(3) = 3.5;
end
if contains(DataType, '1DgVW', 'IgnoreCase', true)
    p0(2) = 1E6.*xScale; lb(2) = 1E6.*xScale; ub(2) = 1E6.*xScale;
end
if fractionFlag
    p0 = p0(2:end); lb = lb(2:end); ub=ub(2:end);
end


options = optimoptions(@lsqcurvefit, 'MaxFunctionEvaluations', length(p0)*1000, 'MaxIterations', 4000,...
    'OptimalityTolerance',1E-10,'FunctionTolerance',1E-10, 'Display','none');

fit = lsqcurvefit(model, p0, x, y, lb, ub, options);

%rescale 
if ~fractionFlag
    fit(2) = fit(2)./xScale; %kd (x when y is half the plateau)
    fit(1) = fit(1)./yScale; %rate coefficient (plateau)
    fit(4) = fit(4)./yScale; % y offset
else
    fit(1) = fit(1)./xScale; %kd 
    fit(3) = fit(3)./yScale; %y offset
end

end

%model 1
% pOn_simple = @(conc, KD) ( conc/KD ./ (1+(conc/KD)) ); %conc in nM

% pOn_simple(dlfluobins, KD_1Dg);

%model 2
% pOn_mwc = @(conc, KD, eps) ( (exp(-beta*eps) + exp(-beta*eps).*(conc/KD))...
%     ./ (1+exp(-beta*eps) + exp(-beta*eps).*(conc/KD)) );

%p(1)- activity coefficient (e.g. initiation rate per fractional
%occupancy), p(2) Kd p(3) cooperativity
% 