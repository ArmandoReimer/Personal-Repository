function surveyImageSmoothingTechniques(im)

figure;
colormap('gray');
tiledlayout('flow');
nexttile;
imagesc(im);
nexttile;
imagesc( wiener2(im));
nexttile;
imagesc(imgaussfilt(im, 2));
nexttile;
imagesc(ordfilt2(im,9,ones(3,3)));
nexttile;
imagesc(ordfilt2(im,5,ones(3,3)));
nexttile;
imagesc(imdiffusefilt(im));
nexttile;
imagesc(imbilatfilt(im));

end