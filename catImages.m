% function catImages()

filterSize = 12;
numFrames = 30;

g = makeGiantImage;
extractFromGiant(g);


function makeGiantImage(im)
gim = gpuArray(im);
nPads = numFrames - 1;
padSize = 2*filterSize;
frameInterval = padSize+size(im,1);
ggiantIm = zeros(size(im,2), size(im,1)*numFrames*size(nPads,1)*nPads, 'gpuArray');
for frame = 1:numFrames
    %   imPath = [PreProcPath, filesep, Prefix, filesep, Prefix, '_', iIndex(currentFrame, 3), '_z', ...
    %                    iIndex(zIndex, 2), nameSuffix, '.tif'];
    %   padIm = padarray(imread(imPath), [0,2*filterSize], 0, 'post');
    
    padIm = padarray(gim, [0,2*filterSize], 0, 'post');
    ind1 = frameInterval*(frame-1) + 1;
    ind2 = frameInterval + (frameInterval*(frame-1));
    
    ggiantIm(:,ind1:ind2) = padIm;
end

% padIm = padarray(gim, [0,2*filterSize], 0, 'post');
% ggiantIm = repmat(padIm, [1,numFrames]);

giantIm = gather(ggiantIm); clear ggiantIm;

end

function im = extractFromGiant(giantIm)

padSize = 2*filterSize;
frameInterval = padSize+size(giantIm,1);

for frame = 1:numFrames
    ind1 = frameInterval*(frame-1) + 1;
    ind2 = frameInterval + (frameInterval*(frame-1)) - padSize;
    im = giantIm(:,ind1:ind2);
end

end
% end