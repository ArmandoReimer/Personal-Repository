function b = sharedparams
% Set up data so that Y is a function of T with a specific functional form,
% but there are three groups and one parameter varies across groups.
close all;
[~, resultsFolder] = getDorsalFolders;
load([resultsFolder, filesep, 'dorsalResultsDatabase.mat'], 'dorsalResultsDatabase')
% enhancers =  {'1Dg11', '1DgS2', '1DgW', '1DgAW3', '1DgSVW2', '1DgVVW3', '1DgVW'};
enhancers =  {'1Dg11', '1DgS2', '1DgW', '1DgAW3', '1DgSVW2', '1DgVVW3'};



%we're going to restrict the range of the fits specifically for each
%enhancer. nan values means no restriction
xrange = nan(length(enhancers), 2);
xrange(1,:)  = [1000, 2250];  %1Dg
xrange(2, :) = [500, 1750]; %upper limit for %1DgS
xrange(3, 1) = 500; %lower limit for 1DgW
xrange(4, 2) = 1500; %upper limit for %1DgAW


nSets = length(enhancers);
xo = {};
yo = {};
xs = {};
ys = {};
dsid = [];
T = [];
Y = [];
for k = 1:nSets
    xo{k} = dorsalResultsDatabase.dorsalFluoBins( ...
        strcmpi(dorsalResultsDatabase.mother,'2x') & strcmpi(dorsalResultsDatabase.enhancer, enhancers{k}) );
    yo{k} = dorsalResultsDatabase.meanFracFluoEmbryo( ...
        strcmpi(dorsalResultsDatabase.mother,'2x') & strcmpi(dorsalResultsDatabase.enhancer, enhancers{k} ) );
    [xs{k}, ys{k}]= processVecs(xo{k}, yo{k}, xrange(k, :));
    dsid = [dsid; k*ones(size(xs{k}))];
    T = [T; xs{k}];
    Y = [Y; ys{k}];
end

gscatter(T,Y,dsid)

%rate, kd, pkd, offset, omegadp
y_max = nanmax(Y);
x_max = max(T);
%amp kd1 kd2 kd3 p/kdp omegadp offset
p0 = [y_max; [x_max/2;x_max;1E5*ones(1, nSets)']; 1 ;0; 1];
% p0 = [y_max; x_max/2 *ones(1, nSets)'; 1 ;0; 1];
lb = [0; 200*ones(1, nSets)'; 0; 0; 1];
ub = [min(1, y_max*2); Inf*ones(1, nSets)'; Inf; y_max*10; Inf];

%%
% Pack up the time and dataset id variables into X for later unpacking
X = [T dsid];

b = lsqcurvefit(@subfun,p0,X,Y);

yfit = subfun(b, X);

t = tiledlayout(1, nSets);
dsid2 = [];

xx = (0:1:max(X(:,1)))';
for k = 1:nSets
    dsid2 = [dsid2; k*ones(length(xx), 1)];
end

X2 = [repmat(xx, nSets, 1), dsid2];
 yfit2 = subfun(b, X2);
 
for k = 1:nSets
%     x = X(X(:, 2)==k);
%     y = yfit(X(:, 2)==k);
%     yy = Y(X(:, 2)==k);
    
  y = yfit2(X2(:, 2)==k);
   
    nexttile;
    plot(xo{k}, yo{k}, xx, y);
    ylim([0, 1]);
    xlim([0, 3500]);
    title(enhancers{k});
    
end

end



function yfit = subfun(params,X)
x = X(:,1);        % unpack time from X
dsid = X(:,2);     % unpack dataset id from X
nSets = max(dsid);

params = params(:)'; %need a row vec

amplitude = params(1);
KD = params(2:nSets+1)';
n = params(nSets + 2);
omegaDP = params(nSets + 3);
offset = params(nSets + 4);

yfit = amplitude.*((n+(x./KD(dsid)).*n.*omegaDP)./(1+x./KD(dsid)+n+(x./KD(dsid)).*n.*omegaDP))+offset;

%     A0 = params(1);    % same A0 for all datasets
%     A1 = params(2:4)'; % different A1 for each dataset
%     tau = params(5);   % same tau
%     yfit = A0 + A1(dsid).*exp(-T/tau);
end