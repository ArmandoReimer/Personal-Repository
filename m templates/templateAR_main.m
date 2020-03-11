function [output1,output2] = function_name(input1,input2,input3, varargin)
%FUNCTION_NAME - One line description of what the function or script performs (H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
%
% Inputs:
%    input1 - Description
%    input2 - Description
%    input3 - Description
%
% Outputs:
%    output1 - Description
%    output2 - Description
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Armando Reimer
% Work address Garcia Lab, UC Berkeley
% email: areimer@berkeley.edu
% Website: http://www.github.com/armandoreimer
% March 2020; Last revision: 10-March-2020

%------------- BEGIN CODE --------------
Enter your executable matlab commands here

%% Constants and optional arguments

displayFigures = false;
keepPool = false;
nWorkers = 1;
output1 = [];
output2 = [];

%Options must be specified as name, value pairs. Unpredictable errors will
%occur, otherwise.
for i = 1:2:(numel(varargin)-1)
    if i ~= numel(varargin)
        eval([varargin{i} '=varargin{i+1};']);
    end
end
%% Argument validation
%% Main section
%% Saving
outPath = '';
mkdir(outPath);
outName = '';
outFile = [outPath, filesep, outName, '.mat'];
save(outFile, 'output1', 'output2', '-v6');
%------------- END OF CODE --------------