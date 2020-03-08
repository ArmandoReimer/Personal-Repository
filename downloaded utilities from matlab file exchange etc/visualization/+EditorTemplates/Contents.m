function Contents
% Contents: list contents and instructions of EditorTemplates package
%
% The EditorTemplates package is a suite of tools used to make templates
% that can then be easily inserted in an active editor window.  The concept
% is similar to having many strings on the clipboard and you can paste them
% into an editor.  This works by taking the selected text or editor file you
% wish to turn into a template (copy) and write it to a function that when
% called inserts the text at the current mouse position in the current
% editor.
%
% This was developed to make it so that frequently used templates do not
% need to be rewritten or copied from a repository.  Instead you can call a
% function (or use the function as a shortcut!) to insert the text when you
% need it.  
%
% There are a few common templates predefined for your use or
% modifications.
%
% Tools for making new templates:
% 
% * <a href="matlab: help newTemplateFromSelection">EditorTemplates.newTemplateFromSelection()</a>
%
%      Creates a new template from all of the text in the current editor
%      window.
%
%
% * <a href="matlab: help newTemplateFromCurrentEditor">EditorTemplates.newTemplateFromCurrentEditor()</a>
%
%      Creates a new template from all of the text selected in the current editor
%      window.
%
% Examples:
%
%      % Select somewhere in an editor that you want a timer:
%      EditorTemplates.Templates.newTimer
%
%      %Make a new function with Sean's default formating:
%      % You may close the editor or create a new blank file:
%      EditorTemplates.Templates.newFun
%
% TIPS:
%
% * To make changes to a template, simply open a new editor file (or close
% the editor) and run the current template so that is is the only text in
% the file.  Make the changes you wish to the template and then rerun:
% 
%     EditorTemplates.newTemplateFromCurrentEditor(current_filename);  
%
% This will overwrite the existing template with the new one.
%

%
% Version 1.0, written in MATLAB 8.0
%

%
% Copyright 2013 The MathWorks, Inc. 
% SCd - MathWorks 02/04/2013
% sean.dewolskiREMOVE_ME@mathworks.com
%

    help EditorTemplates.Contents;
    
end