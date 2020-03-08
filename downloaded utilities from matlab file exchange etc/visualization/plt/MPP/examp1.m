% examp1.m - demonstrates Matlab conditional compilation

%include
% modelA.m
%end_include

 result1 = 45.3 * sin(-6.307 + 8);  % compute an intermediate result

 result2 = sqrt(0.000273) + 604^3;        % compute another intermediate result

 finRes = 1/sqrt(result1 + result2);       % final result
% finRes = abs(result1) / round(result2);   % final result
% finRes = mod(result1,result2);            % final result

 disp('model A is pretty good');
% disp('model B is fantastic');
% disp('model C is out of this world');

disp(sprintf('finRes = %g',finRes));  % display something important
