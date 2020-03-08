% generates noisy AR time-series with change of parameter
function x = GenerateARWithChange( SIZE, ChangeTime, alfaValue)
%
%     SIZE - total size
%     ChangeTime - moment, when parametr of logistic map changes from r1 to r2
%     noiseLevel - level of noise as percentage of standard white noise  
%

%parameters initialization
x (1:SIZE) = 0;
y(1:SIZE) = randn(1,SIZE);
x(1)=pi/4;

n = 1;
changeNumber = length(ChangeTime);
alfa = alfaValue(1);
 
 for i = 1:1:SIZE-1
     if (i == ChangeTime(n))
        alfa = alfaValue(n+1);
        if (n < changeNumber)
            n = n + 1;
        end;    
     end;   
     x (i+1) = alfa*x(i) + y(i+1);   
 end
end

