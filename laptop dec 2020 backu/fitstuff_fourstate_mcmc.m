k = 1;
x = dorsalResultsDatabase.dorsalFluoBins( ...
           strcmpi(dorsalResultsDatabase.mother,'2x') & strcmpi(dorsalResultsDatabase.enhancer, enhancers{k}) );
y = dorsalResultsDatabase.meanFracFluoEmbryo( ...
       strcmpi(dorsalResultsDatabase.mother,'2x') & strcmpi(dorsalResultsDatabase.enhancer, enhancers{k} ) );
y_error = dorsalResultsDatabase.seFracFluoEmbryo( ...
       strcmpi(dorsalResultsDatabase.mother,'2x') & strcmpi(dorsalResultsDatabase.enhancer, enhancers{k} ) );
       
%remove nans from the data for fitting
y_error(isnan(y)) = [];
x(isnan(y)) = [];
y(isnan(y)) = [];

%interpolate the data to be able to fit and get CIs. otherwise the fit is
%impossible since #params ~ #data points. 
scale_interp = 2;
xq = (min(x): mean(diff(x))/scale_interp : max(x) )';
yq = interp1(x,y,xq);

%restrict the range of the fit to a monotonically increasing region

if isnan(xrange(k, 1))
    xrange(k, 1) = xq(1);
end
if isnan(xrange(k, 2))
    xrange(k, 2) = xq(end);
end
    
x1_ind = find(xq==xrange(k, 1));
x2_ind = find(xq==xrange(k, 2));
    
t = xq(x1_ind:x2_ind);
Y=  yq(x1_ind:x2_ind);


model = @(A, k1, k2, k3, k4, r1, r2, r3, r4, offset, x) ...
    ... 
  A.* ( (x.*k2.*k3.*(k1+k4+x.*r2)+k3.*(k4+x.*r2).*r3+(k4+r1+x.*r2).*r3.* ...
  r4).*(x.^2.*k2.*(k3+r1).*r2+(k1+r3).*(k3.*k4+(k4+r1).*r4)+x.*(k2.* ...
  k3.*k4+k1.*k2.*(k3+k4+r1)+(k3+r1).*r2.*r3+r2.*(r1+r3).*r4)).^(-1) ) + offset;

modelStr = func2str(model);
modelStr = strrep(modelStr, '@(A,k1,k2,k3,k4,r1,r2,r3,r4,offset,x)', '@(t, m)');
modelStr = strrep(modelStr, 'x', 't');
modelStr = strrep(modelStr, 'A', 'm(1)');
modelStr = strrep(modelStr, 'k1', 'm(2)');
modelStr = strrep(modelStr, 'k2', 'm(3)');
modelStr = strrep(modelStr, 'k3', 'm(4)');
modelStr = strrep(modelStr, 'k4', 'm(5)');
modelStr = strrep(modelStr, 'r1', 'm(6)');
modelStr = strrep(modelStr, 'r2', 'm(7)');
modelStr = strrep(modelStr, 'r3', 'm(8)');
modelStr = strrep(modelStr, 'r4', 'm(9)');
modelStr = strrep(modelStr, 'offset', 'm(10)');
forwardModel = str2func(modelStr);

m0 = [1, .1, .1, .1, .1, .1, .1, .1, .1, .1]';

sigma=std(Y-forwardmodel(t,m0));
m0=[m0 ; log(sigma)];

% First we define a helper function equivalent to calling log(normpdf(x,mu,sigma))
% but has higher precision because it avoids truncation errors associated with calling
% log(exp(xxx)).
lognormpdf=@(x,mu,sigma)-0.5*((x-mu)./sigma).^2  -log(sqrt(2*pi).*sigma);

logLike=@(m)sum(lognormpdf(Y,forwardmodel(t,m),m(end)));
logprior = @(m)(m(1)>0&m(1)<=1&m(2)>0&m(2)<1E5&m(3)>0&m(3)<1E5&m(4)>0&m(4)<1E5&...
    m(5)>0&m(5)<1E5&m(6)>0&m(6)<1E5&m(7)>0&m(7)<1E5&m(6)>0&m(7)>0&m(7)<1E5&...
    m(8)>0&m(8)<1E5&m(9)>0&m(9)<1E5&m(10)>=0&m(10)<=.3);

% first we initialize the ensemble of walkers in a small gaussian ball
% around the m0 estimate.

% ball=randn(length(m0),30)*0.1;
% ball(:,3)=ball(:,3)*200;
% mball=bsxfun(@plus,m0,ball);

ball=lognrnd(1, 1, length(m0),30);
ball(ball > 10^4) = 10^4;
ball(ball < 0) = .01;
mball = ball;
for k = 1:size(mball, 2)
    if mball(1, k) > 1
        mball(1,k) = 1;
    end
    if mball(10,k) > .3
        mball(10,k) = .3;
    end
end

tic
m=gwmcmc(mball,{logprior, logLike},300000000,'burnin',.3,'stepsize',2, 'ThinChain', 10000);
toc

figure
[C,lags,ESS]=eacorr(m);
plot(lags,C,'.-',lags([1 end]),[0 0],'k');
grid on
xlabel('lags')
ylabel('autocorrelation');
text(lags(end),0,sprintf('Effective Sample Size (ESS): %.0f_ ',ceil(mean(ESS))),'verticalalignment','bottom','horizontalalignment','right')
title('Markov Chain Auto Correlation')

figure
ecornerplot(m,'ks',true,'color',[.6 .35 .3])
figure
m=m(:,:)'; %flatten the chain


%make a 2d histogram of forwardmodel of the posterior samples
ygrid=linspace(min(Y),max(Y),200);
tgrid=min(t):max(t);
Ycount=zeros(length(ygrid),length(tgrid));
for kk=1:1000
    r=ceil(rand*size(m,1));
    Ymodel=forwardmodel(tgrid,m(r,:));
%     Ybin=round((Ymodel-ygrid(1))*length(ygrid)/(ygrid(end)-ygrid(1)));
     Ybin=discretize(Ymodel, size(Ycount, 1));
    for jj=1:length(tgrid)
        Ycount(Ybin(jj),jj)	=Ycount(Ybin(jj),jj)+1;
    end
end
Ycount(Ycount==0)=nan;
h=imagesc(Ycount,'Xdata',tgrid,'Ydata',ygrid);
axis xy

hold on

h=plot(t,Y,'ks','markersize',5);

[~, mm]=kmeans(m, 2); %use Kmeans to characterize two solutions

h(2)=plot(tgrid,forwardmodel(tgrid,mm(1,:)),'color',[.6 .45 .3],'linewidth',2);
h(3)=plot(tgrid,forwardmodel(tgrid,mm(2,:)),'color',[.6 .3 .45],'linewidth',2);

axis tight
legend(h,'Data','Model A','Model B','location','best')