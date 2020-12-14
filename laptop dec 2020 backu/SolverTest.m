%% Test Class Definition
classdef SolverTest < matlab.unittest.TestCase
   
    %% Test Method Block
    methods (Test)
        % includes unit test functions
        
       %% Test Function
       function testRealSolution(testCase)
            %actual solution
            actSolution = quadraticSolver(1,-3,2);
            %expected solution
            expSolution = [2,1];
            %assertion
            testCase.verifyEqual(actSolution,expSolution)
       end 
       
       function testImaginarySolution(testCase)
            actSolution = quadraticSolver(1,2,10);
            expSolution = [-1+3i, -1-3i];
            testCase.verifyEqual(actSolution,expSolution)
        end
       
       
        
    end
end