function [block] = getpct(pctdone,block)
% GETPCT - Returns a value of where the percent bar is.  This was designed
% to replace the waitbar function due to its high overhead.  It only add
% about 10% overhead compared to waitbar's 60-70% overhead.
%
%   [BLOCK] = GETPCT(PCTDONE,BLOCK) - will return the block array with
%       updated values.  PCTDONE is an interger value used to evaluate
%       whether or not to print a percent marker.  Once a value has turned 
%       to 1, then that percent marker can not be used again unless the 
%       BLOCK variable is reset to all zeros.
%
%   EXAMPLE
%
%   pct_count = 1; % BEGINNING VALUE FOR PERCENTAGE BAR
%   pct_skip = 20; % SKIP THIS NUMBER OF LINES BEFORE CHECKING PERCENTAGE AGAIN(SPEED UP ALGORITHM)
%   block = zeros(10,1);
%   disp('LOADING DATA FILE...');
%   for i = 1:1000
%       if pct_count == pct_skip
%           pctdone = floor(100*i/1000);
%           if (pctdone==10)||(pctdone==20)||(pctdone==30)||(pctdone==40)||(pctdone==50)||(pctdone==60)||(pctdone==70)||(pctdone==80)||(pctdone==90)
%               [block] = getpct(pctdone,block);
%           end
%           pct_count = 1;
%       else
%           pct_count = pct_count + 1;
%       end
%       pause(.01);
%   end
%
%   Version: .9 
%   Date: 2005/02/09

    if (pctdone == 10)&(block(1) == 0)
        fprintf('10');
        block(1) = 1;
    elseif (pctdone == 20)&(block(2) == 0)
        fprintf([' 20']);
        block(2) = 1;
    elseif (pctdone == 30)&(block(3) == 0)
        fprintf([' 30']);
        block(3) = 1;
    elseif (pctdone == 40)&(block(4) == 0)
        fprintf([' 40']);
        block(4) = 1;
    elseif (pctdone == 50)&(block(5) == 0)
        fprintf([' 50']);
        block(5) = 1;
    elseif (pctdone == 60)&(block(6) == 0)
        fprintf([' 60']);
        block(6) = 1;
    elseif (pctdone == 70)&(block(7) == 0)
        fprintf([' 70']);
        block(7) = 1;
    elseif (pctdone == 80)&(block(8) == 0)
        fprintf([' 80']);
        block(8) = 1;
    elseif (pctdone == 90)&(block(9) == 0)
        fprintf([' 90\n']);
        block(9) = 1;
    else
        %continue
    end