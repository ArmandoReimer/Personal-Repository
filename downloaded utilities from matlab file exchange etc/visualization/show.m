% function show(varargin)
% 
% Brings up figures given in varargin
% 
% e.g.
%   show        %Brings up all figures
%   show(1)     %Brings up figure 1
%   show(2:5)   %Brings up figures 2,3,4,5
%   show 34567  %Brings up figures 3,4,5,6,7
%               *Only works for single digit figure numbers
% 
% Author: Colin Eaton
%         eatonpi@gmail.com

function show(varargin)

if isempty(varargin)
    figs = sort(get(0,'Children'));
    for ii=1:length(figs)
        figure(figs(ii))
    end
else
    temp = cell2mat(varargin);
	if isnumeric(temp)
        for ii = 1:length(temp)
            figure(temp(ii));
        end
    else
        for ii = 1:length(temp)
            figure(str2num(temp(ii)))
        end
            
    end
end