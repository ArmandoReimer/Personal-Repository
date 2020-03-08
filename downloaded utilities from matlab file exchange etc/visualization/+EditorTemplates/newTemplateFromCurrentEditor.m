function shortcut = newTemplateFromCurrentEditor(templateName)
%newTemplateFromCurrentEditor - Create a new template from the current editor 
%
%Usage:
%   -shortcut = newTemplateFromCurrentEditor(TemplateName);
%   -shortcut = newTemplateFromCurrentEditor();
%
%   This function creates a new template file from the current editor file
%   and returns the shortcut to it.
%
%Inputs:
%   -templateName: String, name of template
%
%Outputs:
%   -shortcut: String, calling syntax for new template (paste this into shortcuts)
%
%See Also: newTemplateFromSelection
%

%
% Copyright 2013 The MathWorks, Inc. 
% SCd - MathWorks 02/04/2013
%

    %Get Editor info:
    hEditor = matlab.desktop.editor.getActive;

    %If it's empty, this function does nothing
    if isempty(hEditor);
        warning('NewTemplate:NoEditor','No Editor Window is open; New Template Not Created');
        return;
    end   

    %Error Checking:
    narginchk(0,1);    %nargin correct
    if ~nargin         %If name not supplied, ask.
        userInput = inputdlg('New Template''s Name:','New Template',1,{'Temp.m'});               
        if isempty(userInput)
            return
        end
        templateName = userInput{1};
    end
    
    %Get the full filename, shortcut
    [fullFilename, shortcut] = getTemplateFullFilename(templateName);
    if isempty(shortcut)
        return
    end
    
    %Get text from editor
    templateStr = hEditor.Text;      
    if isempty(templateStr)
        warning('NewTemplate:NoTextInEditor','No Text in Editor; New Template Not Created');
        shortcut = [];
        return
    end
    
    %Write the Template Function:   
    writeTemplateFunction(templateStr,templateName,fullFilename)
    
end