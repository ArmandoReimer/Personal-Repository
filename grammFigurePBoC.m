function grammFigurePBoC(g,varargin)
%Changes gramm object's color palette and overall style to match PBoC
%figure style. Run this for each individual gramm figure

%Last updated = 4/21/2020 by Jonathan Liu

%Inputs:
%   g = gramm figure object to change

%Variable inputs:
%   'Color', colorstring: force a particular single color (DOESN'T WORK
%   YET)
%       options: 'blue','red','green','purple','yellow'

%% Variable inputs
%Need to update this (JL 4/21/2020)
singleColor = false;
for i = 1:length(varargin)
    if strcmpi(varargin(i),'color')
        singleColor = true;
        colorstring = varargin(i+1);
    end
end
%% Define colormap
%Define color palette (M x 3 array, where M = N_colors x N_lightness
%orde_red by color then lightness)

Dark_blue = [111 157 237];
Med_blue = [173 209 255];
Light_blue = [207 230 255];

Dark_red = [217 77 77];
Med_red = [237 168 168];
Light_red = [245 212 212];

Dark_green = [113 209 82];
Med_green = [186 245 128];
Light_green = [219 255 191];

Dark_purple = [169 121 212];
Med_purple = [218 194 242];
Light_purple = [237 225 250];

Dark_yellow = [232 193 74];
Med_yellow = [242 220 160];
Light_yellow = [255 240 204];

Light_beige = [230 230 214]; %Background figure color

PBoC_colormap = [Dark_blue; Med_blue; Light_blue; Dark_red; Med_red;...
    Light_red; Dark_green; Med_green; Light_green; Dark_purple; Med_purple;...
    Light_purple; Dark_yellow; Med_yellow; Light_yellow] ./ [255 255 255];


%% Change to PBoC colors
for i = 1:size(g,1)
    for j = 1:size(g,2)
        g(i,j).set_color_options('map',PBoC_colormap,'n_color',5,'n_lightness',3);
        g(i,j).set_text_options('font','Lucida Sans','base_size',12,'title_scaling',1.2,...
            'big_title_scaling',1.2);
    end
end


end