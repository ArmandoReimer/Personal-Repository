% generates noisy logistic map with change of parameter
function x = GenerateLogisticWithChange( lengthTS, changeTime, rValue, noiseLevel )
%
%     lengthTS - total size
%     changeTime - moments, when parameter of logistic map changes 
%     rValue - array of control parameters of logistic map
%     noiseLevel - level of noise as percentage of standard white noise  
%

  nSegment = length(changeTime) + 1;

  %if noise level is the same for all signal - make changeNumber copies of it
  if (length(noiseLevel) == 1)
    noiseLevel(2:nSegment) = noiseLevel(1);
  end  

  x = zeros(1, lengthTS);
  noise = randn(1, lengthTS);
  noise(1) = noise(1)*noiseLevel(1);
  x(1) = pi/4;
  iSegment = 1;
  for i = 1:lengthTS-1
    if ((iSegment < nSegment) && (i >= changeTime(iSegment)))    
      iSegment = iSegment + 1;
    end   
    x(i+1) = rValue(iSegment)*(1-x(i))*x(i);  
    noise(i+1) = noiseLevel(iSegment)*noise(i+1);
  end
  x = x + noise;
end

