function moveToBase(var)
%wrapper for assignin to move variable from current workspace to base with
%the same name

assignin('base', inputname(1), var); 

end