function [fullFilename, shortcut] = getTemplateFullFilename(templateName)
% getTemplateFullFilename(templateName) - validate templateName and return
% path and shortcut
%
%Usage:
%   -[fullFilename, shortcut] = getTemplateFullPath(templateName)
%
%   WARNING! This is a helper function used by higher level functions that
%   do error checking to make sure this file does not break things.  Don't
%   call it explitly!
%
%Inputs:
%   -templateName: name of function file to be called
%
%Outputs:
%   -fullFilename: string, full filename of new template function
%
%   -shortcut:     string, calling syntax for new template function
%                  NOTE: if this is empty, the template will not be written
%
%See Also: WriteTemplateFunction, newTemplateFromCurrentEditor
%

%
% Copyright 2013 The MathWorks, Inc. 
% SCd - MathWorks 02/04/2013
%

    %Rudimentary nargin checking:
    narginchk(1,1);

    %TemplateName needs to be a character vector with a valid variable name
    %ending in '.m'
    validateattributes(templateName,{'char'},{'nonempty'},mfilename,'templateName',1)    
    assert(strcmp(templateName(end-1:end),'.m'),'Expected Template Name to have *.m Extension');
    assert(isvarname(templateName(1:end-2)),'Expected Template Name to be a valid name');
    
    %Directory and filename
    directory = mfilename('fullpath');
    idxKeep = strfind(directory,'\private\'); %last private file 
    idxKeep = idxKeep(end);
    fullFilename = [directory(1:idxKeep) '+Templates' filesep templateName]; %build filename
    shortcut = ['EditorTemplates.Templates.' templateName(1:end-2)]; %whjat to call        
    
    %Figure out if the file exists
    fid = fopen(fullFilename,'r');
    if fid ~= -1
        %The file exists
        fclose(fid);
        button = questdlg(sprintf('Do you wish to overwrite: %s',templateName),...
            'File Already Exists','Yes','No','Yes');
        if strcmp(button,'No')
            warning('NewTemplate:NoOverwrite','New template has not been created because the filename already exists');
            shortcut = []; %no shortcut
        end            
    end
end    