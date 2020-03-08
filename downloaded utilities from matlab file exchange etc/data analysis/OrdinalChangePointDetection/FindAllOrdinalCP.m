% FindAllOrdinalCP.m - detects structural change-points by using CEofOP statistic
%                     returns positions of all detected change-points              
% Please refer to:
% [1] Unakafov, A.M. and Keller, K. (2015). 
% Change-point detection using the conditional entropy of ordinal patterns.
% https://arxiv.org/abs/1510.01457
%
% [2] Unakafova, V. A., and Keller, K. (2013). 
% Efficiently Measuring Complexity on the Basis of Real-World Data. 
% Entropy, 15(10), 4392-4415. 
%
%
% INPUT 
%   - timeSeries - time series where change-points are searched
%   - order - order of ordinal patterns; order = 3 is recommended, order 2 can also be used 
%   - falseAlarmRate - assigned probability of a false alarm (erroneously
%                      detected change-point in a stationary signal), 
%                      falseAlarmRate = 0.05 is acceptable in many cases. 
%   - minCPdist - minimal distance between change-points (minimal expected 
%                 length of a stationary segment). 
% Note that for reliable estimation of change points, the following condition 
% should be satisfied:
%       minCPdist > factorial(order + 1)*(order + 1) 
% That is minCPdist >= 100 is required for order = 3 and 
% minCPdist >= 20 is required for order = 2
%      
% OUTPUT: CPlocations - change point positions or zero if no CP is found
%
%
% Please refer to:
% [1] Unakafov, A.M. and Keller, K. (2015). 
% Change-point detection using the conditional entropy of ordinal patterns.
% https://arxiv.org/abs/1510.01457
%
% Abbreviations: OP - ordinal pattern
%                CP - change-point
%
%

function CPlocations = FindAllOrdinalCP(timeSeries, order, falseAlarmRate, minCPdist)           

  delay = 1; % in this version we consider only delay = 1;
  [opSeries, opPair] = CalcOrdinalTimeSeries(timeSeries, order, delay);

  opSeriesLength = length(opPair);
  CPlocations = [];

  noBootstrap = 0;
  MAX_LEN_FOR_BOOTSTRAP = 100000;

  
  if (opSeriesLength > MAX_LEN_FOR_BOOTSTRAP)
    %if the time series is too long then bootstrapping for each change point takes much time 
    noBootstrap = 1;
  
    %instead we calculate two thesholds for falseAlarmRate now, by bootstraping the whole time series only once
    nPatterns = factorial(order+1);% the number of ordinal patterns of given order     
    opDistr   = zeros(1, nPatterns); % the distribution of the ordinal patterns
    op2Distr  = zeros(1, nPatterns*(order+1)); % the distribution of the ordinal pattern pairs
    for i = 1:opSeriesLength          
      pattern = opSeries(i);   
      word2 = opPair(i);   
      opDistr(pattern) = opDistr(pattern)+1;
      op2Distr(word2) = op2Distr(word2)+1;          
    end
   
    blockSize = order + 1; 
    blockedTSlength = floor(opSeriesLength/blockSize);
    blockedTSsize = blockedTSlength*blockSize;
    X = reshape(opPair(1:blockedTSsize), blockSize, blockedTSlength);
    
    Nboot = max(floor(5/min(falseAlarmRate)), 500);
    val = zeros(1, Nboot);  
    for i = 1:Nboot
      mixedOpPair = reshape(datasample(X, blockedTSlength, 2,'Replace',false), 1, blockedTSsize);
      mixedOpSeries = floor((mixedOpPair - 1)./ (order + 1)) + 1;
      val(i) = CEofOP_Statistic(mixedOpSeries, mixedOpPair, opDistr, op2Distr, order, 1);
    end
    val = sort(val, 'descend');
    threshold1 = val(2*Nboot*falseAlarmRate);
    threshold2 = val(Nboot*falseAlarmRate);
    clear X mixedOpPair mixedOpSeries val blockSize blockSize blockSize opDistr op2Distr pattern word2 nPatterns;
  end



  %% first step: preliminary search of change points
  %  we check all intervals between already determined change-points
  nCP = 0; %we start with 0 change-points
  iCP = 0;    
  while iCP <= nCP  %we have nCP change points, thus - (nCP + 1) intervals to check
    if (iCP == 0)	%the first interval starts from the first point of time series
       start = 1;
    else   		%other intervals start at some distance after the previous change-point
       start = CPlocations(iCP) + minCPdist/2;
    end        
    if (iCP == nCP) %the last interval ends with the last point of time series
       finish = opSeriesLength;
    else		%other intervals end at some distance before the next change-point	
       finish = CPlocations(iCP + 1) - minCPdist/2;
    end   
            
    if (finish - start >= minCPdist)           
      if (noBootstrap)
        [cpPos, isDetected] = FindOrdinalCP(opSeries(start:finish), opPair(start:finish), order, 0, threshold1);
      else
        [cpPos, isDetected] = FindOrdinalCP(opSeries(start:finish), opPair(start:finish), order, 2*falseAlarmRate);
      end
    else
      isDetected = 0; 
    end   
    
    if (isDetected > 0)    %if CP was found         
      cpPos = start + cpPos;
               
      if (iCP == 0)
        if (isempty(CPlocations))
          CPlocations = cpPos;
        else
          CPlocations = [cpPos, CPlocations(1:end)]; 
        end
      else
        if (iCP < length(CPlocations))
          CPlocations = [CPlocations(1:iCP), cpPos, CPlocations(iCP+1:end)];
        else
          CPlocations = [CPlocations(1:iCP), cpPos];
        end 
      end   
      nCP = nCP + 1;
    else
      iCP = iCP + 1; 
    end %if (isDetected > 0)    
  end  

  if (isempty(CPlocations)) %if no CP found - add 0 to the list and leave
    CPlocations(1) = 0;
    return;
  end 


  % second step: we check CP with higher threshhold, remove false CP and
  %  specify positions of the true CP
  nCP = length(CPlocations);
  iCP = 1;
    
  while (iCP <= nCP)  %until not all change-points are checked
    if (iCP == 1)     %the first interval starts from 1
      start = 1;
    else                        
      start = CPlocations(iCP - 1) + minCPdist/2;         
    end        
    if (iCP == nCP)   %the last interval ends with the last point of time series
      finish = opSeriesLength;
    else                             
      finish = CPlocations(iCP + 1) - minCPdist/2;
    end   
   
    if ((finish - start + 1) < minCPdist)
      isDetected = 0; %we got CP to near to the border or other CP and remove it 
    else
      if (noBootstrap)%try again to find change-point for this interval
         [cpPos, isDetected] = FindOrdinalCP(opSeries(start:finish), opPair(start:finish), order, 0, threshold2);
      else
         [cpPos, isDetected] = FindOrdinalCP(opSeries(start:finish), opPair(start:finish), order, falseAlarmRate);
      end
    end
      
    if (isDetected > 0)                 %if CP-level is above threshold 
      CPlocations(iCP) = start + cpPos; %we refine the CP position
      iCP = iCP + 1;                    %and go to the next point
    else
      CPlocations(iCP) = [];            %otherwise we just remove the change-point
      if (iCP > 1)                      %and return to previous point if there is one
         iCP = iCP - 1;                 %to refine it's position
      end   
      nCP = nCP-1;
    end
  end   

  %if no CP found - add 0 to the list
  if (isempty(CPlocations))                   
    CPlocations(1) = 0;
  end   
end  





% Calculate sequence of OP and of OP pairs for given signal x, order and delay.
%
function [opSeries, opPair] = CalcOrdinalTimeSeries(x, order, delay)
  load(['table' num2str(order) '.mat']);

  xLength = numel(x);  % the length of the time series
  order1 = order + 1;  % for fast computation
  orderTimesDelay = order*delay;
  windowSize = xLength - orderTimesDelay;
  nPatterns = factorial(order1);% the number of ordinal patterns of given order     
  opSeries = zeros(1, windowSize); % the sequence of the OP pairs
  opPair = zeros(1, windowSize - delay); % the sequence of the ordinal patterns
        
  ancNumArray = nPatterns./factorial(2:order1); % the ancillary numbers for computation ordinal numbers    
  patTable = eval(['table' num2str(order)]);
         
  for iDelay = 1:delay  
    % a computation of the first ordinal number          
    %pattern = sum(invNum.*ancNumArray); % the first ordinal pattern
    pattern = 1; 
    for j = 1:order
      invNum = sum(x((order - j)*delay + iDelay) >= ...
                   x( ((order1 - j)*delay + iDelay):delay:(orderTimesDelay + iDelay)));    
      if (invNum~=0)
        pattern = pattern+invNum*ancNumArray(j);
      end
    end
    opSeries(iDelay) = pattern;
                
    % the ordinal distribution for the window
    for j = (orderTimesDelay + delay + iDelay):delay:(windowSize + orderTimesDelay)
      % pos = sum(x(j-orderTimesDelay:delay:j) >= x(j));
      word2 = (pattern - 1)*order1;    
      for l = (j - orderTimesDelay):delay:j 
        if (x(l) >= x(j))
          word2 = word2 + 1;
        end
      end
      pattern = patTable(word2) + 1;    
      opSeries(j - orderTimesDelay) = pattern;
      opPair(j - orderTimesDelay - delay) = word2;
    end       
  end
end    


% CEofOP_Statistic - calculates the CEofOP statistics for each point of a time series.
% Ref: Unakafov, A. M., & Keller, K. (2016). 
%
% INPUT: opSeries - sequence of ordinal patterns
%        opPair - sequence of ordinal pattern pairs ("2-d words"), 
%        opDistr - overall distribution of ordinal patterns 
%                  (should be precomputed for optimizational reasons),
%        op2Distr - overall distribution of ordinal pattern pairs 
%                  (should be precomputed for optimizational reasons),
%        order - order of ordinal patterns
%        delay - delay (lag used for computing ordinal patterns)
% OUTPUT: CPval  - maximal value of the statistic
%         CPpos  - argmax of the statistic (the estimate of the change-point)
%         CEofOP - all values of the statistic

function [CPval, CPpos, CEofOP] = CEofOP_Statistic(opSeries, opPair, opDistr, op2Distr, order, delay)   
  order1 = order + 1;    % for fast computation
  orderTimesDelay = order*delay;
  windowSize = length(opPair); %we do not calculate the last pattern to have the same distribution as for joint probab
  nPatterns = factorial(order1);% the number of ordinal patterns of order d     
  
  tablePE = zeros(1, windowSize); 
  tablePE(1:windowSize) = (1:windowSize).*log(1:windowSize);
  tablePE(2:windowSize) = tablePE(2:windowSize)-tablePE(1:windowSize-1);
    

  CE0 = (nansum(opDistr.*log(opDistr)) - nansum(op2Distr.*log(op2Distr)))...
          *(windowSize - order - delay + 1)/(windowSize - delay + 1);  %compute CE of whole time series
  minWindowSize = max([nPatterns*order 24*3]); %minimal length of window for correct estimation of CE     
  
  %we ignore the last pattern to have compatibility with opPair
  opSeries(windowSize - delay + 1:end) = [];    

  %opDistrRight, op2DistrRight - distributions of OPs and OP pairs to the left from CP
  opDistrLeft  = zeros(1, nPatterns);
  op2DistrLeft = zeros(1, nPatterns*order1);  
  
  %opDistrRight, op2DistrRight - distributions of OPs and OP pairs to the right from CP
  opDistrRight = opDistr;
  op2DistrRight = op2Distr;  
  %remove from all instances related to first (orderTimesDelay-1) patterns
  %they correspond to the gap between windows for computing CE on the left and on the right from CP
  for t = 1:(orderTimesDelay-1)
    opRight   = opSeries(t);       
    op2Right = opPair(t);       
    opDistrRight(opRight)   = opDistr(opRight)   - 1;  
    op2DistrRight(op2Right) = op2Distr(op2Right) - 1; 
  end 
    
  %compute distributions of OP and OP pairs corresponding to CP at minWindowSize 
  for t = 1:minWindowSize
    opLeft   = opSeries(t); %OP with last point at (t + orderTimesDelay)
    op2Left = opPair(t); %OP pair with last point at (t + orderTimesDelay + delay)
    opDistrLeft(opLeft)   = opDistrLeft(opLeft)   + 1; % add OP for left window
    op2DistrLeft(op2Left) = op2DistrLeft(op2Left) + 1; % add OP pair for left window
       
    opRight  =  opSeries(t + orderTimesDelay - 1);   %OP with last point at (t + orderTimesDelay + orderTimesDelay - 1), that is we skip (orderTimesDelay - 1) OPs that contain the CP
    op2Right =  opPair(t + orderTimesDelay - 1);  %OP pair with last point at(t + orderTimesDelay + orderTimesDelay + delay - 1)        
    opDistrRight(opRight)   = opDistrRight(opRight)  - 1;  %remove OP from right window
    op2DistrRight(op2Right) = op2DistrRight(op2Right) - 1; %remove OP pair from right window
  end 
  CE1 = nansum(opDistrLeft.*log(opDistrLeft)) - nansum(op2DistrLeft.*log(op2DistrLeft));
  CE2 = nansum(opDistrRight.*log(opDistrRight)) - nansum(op2DistrRight.*log(op2DistrRight));
    
  %compute values of CEofOP statistic     
  CEofOP = zeros(1, windowSize) ;
  for t = (minWindowSize+1):(windowSize-delay-orderTimesDelay-minWindowSize) 
    %for each t we expand left window and reduce right window
    %to compute values of CE to the left and to the right of t    
    opLeft  =  opSeries(t);  %OP with last point at (t + orderTimesDelay)
    op2Left =  opPair(t); %OP pair with last point at (t + orderTimesDelay + delay)
    opDistrLeft(opLeft)   = opDistrLeft(opLeft)  +1; % new pattern for 1st window
    op2DistrLeft(op2Left) = op2DistrLeft(op2Left)+1; % new word  for 1st window
        
    opRight  =  opSeries(t + orderTimesDelay - 1);  %OP with last point at (t + 2*orderTimesDelay - 1)
                                %that is we skip (orderTimesDelay - 1) OPs containing the CP
    op2Right =  opPair(t + orderTimesDelay - 1); %corresponds to point of time series x(t + orderTimesDelay + orderTimesDelay + delay - 1)
     
    %re-compute values of CE to the left and to the right of t    
    CE1 = CE1 + (tablePE(opDistrLeft(opLeft))   - tablePE(op2DistrLeft(op2Left)));
    CE2 = CE2 - (tablePE(opDistrRight(opRight)) - tablePE(op2DistrRight(op2Right)));
    
    %compute the value of statistic    
    CEofOP(t + orderTimesDelay + delay) = CE0 - CE1 - CE2;
        
    opDistr(opRight)   = opDistr(opRight)  -1; % old pattern  for 2nd window
    op2Distr(op2Right) = op2Distr(op2Right)-1; % old word for 2nd window
  end
        
  CPval  = max(CEofOP);        %find maximal value of statistic 
  tmp = find(CEofOP == CPval); %if there are several points with maximal value 
  CPpos = tmp(end);            %we take the rightmost. 
end   


% FindOrdinalCP - detects single structural change-point using CEofOP statistic
%                 returns the position of the most prominent change-point
%                 and whether it is a real CP for the given threshold                

% INPUT (opSeries - OP sequencs, opPair - OP pairs sequencs, order - order of OP, 
%        falseAlarmRate - array of false errors rates for choosing threshold 
%        !!!every element of falseAlarmRate divided by the minimal element should provide integer value!!! 
%        if falseAlarmRate == 0 then no check of CP is requested, we just return the position maximizing the statistics
%        threshold - optional parameter, the value of threshold. If defined, bootstraping procedure is omited
%                    - combined with falseAlarmRate = 0
% OUTPUT changePoint - change point position 
%        isDetected -  1 if the statistics for the CP is below the
%                      threshold, and 0 otherwise
function [CPpos, isDetected] = FindOrdinalCP(varargin)           
  if (nargin < 4) %not enough argumants
    error('FindOrdinalCP:error1','Incorrect number of arguments.') 
    CPpos = -1; 
    isDetected = -1;
    return;
  end
  opSeries = varargin{1}; 
  opPair = varargin{2};
  order = varargin{3};
  falseAlarmRate = varargin{4};

  WS = length(opPair);
  nPatterns = factorial(order + 1);% the number of ordinal patterns of given order    
  opDist     = zeros(1, nPatterns); % the distribution of the ordinal patterns
  op2Dist    = zeros(1, nPatterns*(order + 1)); % the distribution of the ordinal patterns

  if (nargin > 4) %if the optional argument is defined
    threshold = varargin{5};%*WS;
  else
    threshold = 0; 
  end
    
  for i = 1:WS           
    pattern = opSeries(i);   
    word2 = opPair(i);   
    opDist(pattern) = opDist(pattern)+1;
    op2Dist(word2) = op2Dist(word2)+1;          
  end

  [CPval, CPpos] = CEofOP_Statistic(opSeries, opPair, opDist, op2Dist, order, 1);
   
  %if the check of CP is requested - solve the two-sample problem as well
  isDetected = zeros(1, length(falseAlarmRate));
  if (falseAlarmRate > 0)
    %we use block bootstraping since TS is not independent 
    blockSize = order + 1; 
    blockedTSlength = floor(WS/blockSize);
    blockedTSsize = blockedTSlength*blockSize;
    X = reshape(opPair(1:blockedTSsize), blockSize, blockedTSlength);
    
    Nboot = max(floor(5/min(falseAlarmRate)), 500);
    numExceeds = 0;  
    for i = 1:Nboot
      mixedOpPair = reshape(datasample(X, blockedTSlength, 2,'Replace',false), 1, blockedTSsize);
      mixedOpSeries = floor((mixedOpPair - 1)./ (order + 1)) + 1;
      val = CEofOP_Statistic(mixedOpSeries, mixedOpPair, opDist, op2Dist, order, 1);
      if (CPval > val)
        numExceeds = numExceeds + 1;
      end
    end

    for j = 1:length(falseAlarmRate)
      if (numExceeds > Nboot*(1 - falseAlarmRate(j)))  %if CP-level is above threshold
        isDetected(j) = 1;            
      end
    end
  else
    if ((threshold > 0) && (CPval > threshold)) %if the threshold defined and exceeded
      isDetected(1) = 1; 
    end
  end    
end
