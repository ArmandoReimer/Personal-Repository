function smoothTile(im, sigmaRange, nTiles)

figure('Units', 'normalized', 'Position', [.25, .25, .5, .5]);
tiledlayout('flow', 'TileSpacing', 'none', 'Padding', 'none')

sigmas = linspace(sigmaRange(1),sigmaRange(2), nTiles);
colormap('hsv');
for s = sigmas
    
    ax = nexttile;
    imagesc(ax, imgaussfilt(im, s))
    colorbar;

    ax.Visible = 'off';
    title(ax, ['$\sigma$=', num2str(s)], 'Interpreter', 'latex');
    set(findall(ax, 'type', 'text'), 'Visible', 'on')
    axis image

    drawnow;
    
end

end