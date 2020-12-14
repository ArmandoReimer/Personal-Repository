classdef kalman()
%%    
    properties   
        A = 1;
        Q = 2^2;
        H = 1;
        R = 2^2;
        x0 = nan;
        P0 = nan;   
    end
    
    properties(Hidden)
        x double
        P double
        B = 0;
        u  = 0;
    end
 %%  
    methods
        %% Constructor
        function s = kalman(A, Q, H, R, x0, P0)
            
                s.A = A;
                s.Q = Q;
                s.H = H;
                s.R = R;
                s.x = x0;
                s.P = P0;

                s.B = 0;
                s.u = 0;
        end
        
        %% methods
    end
    
end