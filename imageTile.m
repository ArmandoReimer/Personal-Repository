function imageTile(imageCell, titleCell)

set(gcf, 'Units', 'normalized', 'Position', [.25, .25, .5, .5]);
colormap('jet');
tiledlayout('flow', 'TileSpacing', 'none', 'Padding', 'none')

for i = 1:length(imageCell)
    im = imageCell{i};
    str = titleCell{i};
    nexttile;
    imagesc(im); axis image; c = colorbar('Location', 'east'); c.YAxisLocation = 'right';
    title(str); ax = gca; ax.Visible = 'off'; set(findall(ax, 'type', 'text'), 'Visible', 'on')
end



