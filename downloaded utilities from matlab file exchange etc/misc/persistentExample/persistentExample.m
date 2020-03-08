%% Persistent Example
% This example demonstrates how to use persistent variables when loading
% data in a function. Doing things this way guarantees that the "data"
% value in |persistentFunction| is only loaded or changed when necessary.
%
% Note that, I have a hunch that MATLAB may actually recognize a function
% is called repeatedly loading a mat file when not using persistent. It may
% do a form of what "persistentFunction" does with not loading the mat
% file implicitly. If know for sure about this behavior, please inform me.

%% persistentFunction Code
%
% <html>
% <iframe src="persistentFunction.html" width="100%" height="100%"></iframe>
% </html>
%


%% Prepare workspace and command line
clc;
clear all; %#ok<CLALL> % clears the persistent variables. Be careful with this!!!

%% call persistentFunction the first time
persistentFunction(1)
%% call persistentFunction again with the same value
persistentFunction(1)
%% call persistentFunction and change the value
persistentFunction(2)
%% call persistentFunction and change the value
persistentFunction(1)
%% call persistentFunction and change the value
persistentFunction(2)
%% call persistentFunction again with the same value
persistentFunction(2)
%% call persistentFunction with a bad input value
try
    persistentFunction(3)
catch me
    % turn the error to a warning
    warning(me.message);
end
%% call persistentFunction again with the same value that last worked
persistentFunction(2)