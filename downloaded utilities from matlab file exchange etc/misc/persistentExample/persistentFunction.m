function output = persistentFunction(input)
% persistentFunction loads data between calls and changes it when the input
% changes.

persistent data inputPrevious

% - Check if this is the first time the function is called.
% - If it isn't the first time, check if the input has changed.
if isempty(inputPrevious) || inputPrevious~=input
    switch input
        case 1
            fprintf('file1.mat loaded.\n');
            d = load('file1.mat');
            data = d.c;
        case 2
            fprintf('file2.mat loaded.\n');
            d = load('file2.mat');
            data = d.c;
        otherwise
            % 99% of the time you should use an otherwise statement to
            % handle ways you didn't intend to call this function. This
            % will help catch bugs when you do something you didn't intend
            % to do.
            error('Input value not valid. No file loaded.');
    end
    % save the input last so that an error is thrown if a bad input value is
    % passed in. We do not save the bad input into inputPrevious.
    inputPrevious = input;
else
    fprintf('No file loaded on this call.\n');
end

% pass data to the output just for demonstration purposes
output = data;


end

