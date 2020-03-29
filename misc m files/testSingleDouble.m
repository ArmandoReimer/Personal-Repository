close all;

z = 18;
imPath = 'E:\Armando\LivemRNA\Data\PreProcessedData\2015-07-25-P2P_75uW_bi_short\stacks\025_ch01.tif';
im3D = double(readTiffStack(imPath));
imSnippetSingle = single(im3D);
imSnippetDouble = double(im3D);

s = filterImage(imSnip3DSingle, 'Difference_of_Gaussian', {3, 10});
d = filterImage(imSnip3D, 'Difference_of_Gaussian', {3, 10});

figure(1)
subplot(1, 3, 1)
imshow(s(:,:,18), [median(s(:)), max(s(:))])
title('filtered single')

subplot(1, 3, 2)
imshow(d(:,:,18), [median(d(:)), max(d(:))])
title('filtered double')

title('filtered imshowpair single and double')
subplot(1, 3, 3)
% imshowpair(s(:,:,18), d(:,:,18))
% diff = s ~= d;
diff = double(s) - d;
imshow(diff(:,:,18),[median(diff(:)), max(diff(:))])
title('filtered imshowpair single and double')


figure(2)
title('raw single')
subplot(1, 3, 1)
imshow(imSnippetSingle(:,:,18), [median(imSnippetSingle(:)), max(imSnippetSingle(:))])
title('raw double')
subplot(1, 3, 2)
imshow(imSnippetDouble(:,:,18), [median(imSnippetDouble(:)), max(imSnippetDouble(:))])
% title('raw imshowpair single and double')
% subplot(1, 3, 3)
% imshowpair(imSnippetSingle(:,:,18), imSnippetDouble(:,:,18))


