function [smths, outs] = smoothTile(im, sigmaRange, nTiles, varargin)

%purpose: visualize scale-space representations of your image

clrmp = 'jet';
fun = @(x) x; %apply some operation after smoothing 
displayFigures = true;

for i = 1:(numel(varargin)-1)
    if i ~= numel(varargin)
        if ~ischar(varargin{i+1})
            eval([varargin{i} '=varargin{i+1};']);
        end
    end
end

df = displayFigures;

if df
    figure('Units', 'normalized', 'Position', [.25, .25, .5, .5]);
    tiledlayout('flow', 'TileSpacing', 'none', 'Padding', 'none')
    colormap(clrmp);
end

sigmas = linspace(sigmaRange(1),sigmaRange(2), nTiles);

outs = zeros(size(im, 1), size(im, 2), nTiles);
smths = zeros(size(im, 1), size(im, 2), nTiles);
n = 0;

for s = sigmas
    
    n = n + 1;
    
    if df
        ax = nexttile;
    end
    
    smth = imgaussfilt(im, s);
%     smth = imdilate(smth, se);
    smths(:, :, n) = smth;  
    funSmth = fun(smth);
%     funSmth = funSmth==2 | funSmth==3 | funSmth==4;
    outs(:, :, n) = funSmth;
    
    if df
        imagesc(ax, funSmth);
        colorbar;
        ax.Visible = 'off';
        title(ax, ['$\sigma$=', num2str(s)], 'Interpreter', 'latex');
        set(findall(ax, 'type', 'text'), 'Visible', 'on')
        axis image

        drawnow;
    end
    
end

end