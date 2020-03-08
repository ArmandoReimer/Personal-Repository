function for_loop_progress(i,len,step,Nincr)

%%% written by Iason Grigoratos %%%

%%% simple & fast way to display the progress percentage of a for loop
%%% which starts at "i", ends at "len" with a step equal to "step"
%%% Nincr is the number of outputs asked (equal intervals equal to 100/Nincr)

%%%%%% EXAMPLE %%%%%

% i=1; step=1; len=20; Nincr=10;
% for i:step:len
%   for_loop_progress(i,len,step,Nincr);
% end

%%%%%% EXAMPLE %%%%%
if nargin<3, step=1; end % default: step=1
if nargin<4, Nincr=5; end % default: every 20%

incr=1/(Nincr);
for j=1:Nincr
    if  round(j*incr*len)-i<step && round(j*incr*len)-i>=0
        display([num2str(j*incr*100),'%'])
    end
end
end % function
