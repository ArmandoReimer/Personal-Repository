function sharedparams2
% Set up data so that Y is a function of T with a specific functional form,
% but there are three groups and one parameter varies across groups.
t1 = (0:10)'; t2 = (0:2:10)'; t3 = (2:9)';
T = [t1; t2; t3];
Y = 3 + [exp(-t1/2); 2*exp(-t2/2); 3*exp(-t3/2)] + randn(size(T))/10;
dsid = [ones(size(t1)); 2*ones(size(t2)); 3*ones(size(t3))];
gscatter(T,Y,dsid)
% Pack up the time and dataset id variables into X for later unpacking
X = [T dsid];
b = nlinfit(X,Y,@subfun,ones(1,5))
tt = linspace(0,10)';
line(tt,b(1)+b(2)*exp(-tt/b(5)),'color','r')
line(tt,b(1)+b(3)*exp(-tt/b(5)),'color','g')
line(tt,b(1)+b(4)*exp(-tt/b(5)),'color','b')
end
function yfit = subfun(params,X)
T = X(:,1);        % unpack time from X
dsid = X(:,2);     % unpack dataset id from X
A0 = params(1);    % same A0 for all datasets
A1 = params(2:4)'; % different A1 for each dataset
tau = params(5);   % same tau
yfit = A0 + A1(dsid).*exp(-T/tau);
end