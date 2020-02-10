function [ProjectionType, nonInverted, inverted] = makeNuclearProjection_CNT(nCh)

%gui for changing nuclear projection in the checknucleisegmentation script


% lays out user interface
screen_size = get(0, 'screensize');
dim = [screen_size(3) * 0.6, screen_size(4) * 0.75];
dimVec = [dim(1), dim(2), dim(1), dim(2)]; %to easily normalize units

% sets up channel dropdown options
options = cell(1, nCh);

for j = 1:nCh
    options{j} = ['Channel ' num2str(j)];
end


fig = uifigure('Position', [100, 100, dim(1), dim(2)], 'Name', 'Choose Histone Channels');


% Create List Box
channel_list = uilistbox(fig, 'Position', [10, dim(2) * 0.77, dim(1) * 0.125, dim(2) * 0.15], ...
    'MultiSelect', 'on', 'Items', options, ...
    'Value', {'Channel 1'});

invert_label = uilabel(fig, 'Position', [dim(1) * 0.2, dim(2) * 0.93, dim(1) * 0.125, dim(2) * 0.05], ...
    'Text', 'Inversions');
invert_list = uilistbox(fig, 'Position', [dim(1) * 0.2, dim(2) * 0.77, dim(1) * 0.125, dim(2) * 0.15], ...
    'MultiSelect', 'on', 'Items', options, ...
    'Value', {});

proj_type_label = uilabel(fig, 'Position', [dim(1) * 0.4, dim(2) * 0.93, dim(1) * 0.125, dim(2) * 0.05], ...
    'Text', 'Projection Type');
proj_type_dropdown = uidropdown(fig, 'Position', ...
    [dim(1) * 0.4, dim(2) * 0.85, dim(1) * 0.125, dim(2) * 0.08], ...
    'Items', {'maxprojection', 'medianprojection', 'middleprojection'}, ...
    'Value', {'maxprojection'});


okay_button = uibutton(fig, 'Text', 'Okay', 'Position', ...
    [dim(1) * 0.6, dim(2) * 0.85, dim(1) * 0.2, dim(2) * 0.08]);

okay_button.ButtonPushedFcn = @saveOptions;

uiwait(fig);

function saveOptions(~, ~)
    
    nonInvertedCell = channel_list.Value;
    invertedCell = invert_list.Value;
    inverted = [false false false];
    nonInverted = [false false false];
    
    for j = 1:length(invertedCell)
        ch = str2double(invertedCell{j}(9));
        inverted(ch) = true;
    end
    for j = 1:length(nonInvertedCell)
        ch = str2double(nonInvertedCell{j}(9));
        nonInverted(ch) = true;
    end
    
     ProjectionType = proj_type_dropdown.Value;
    if strcmpi(ProjectionType, 'customprojection')
        ProjectionType = [ProjectionType ':' num2str(max_custom) ':' num2str(min_custom)];
    end
        
    close(fig);
end

end

