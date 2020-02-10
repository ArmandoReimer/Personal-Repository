%bright
% nodc = brightlog - mean(brightlog(:));
nodc = im - mean(im);
% nodc = darklog - mean(darklog);
imgfftred = fftshift(fft2(nodc));
figure(1); imshow(abs(imgfftred), []);
xlim([240, 280])
ylim([240, 280])
in1 = ifftshift(imgfftred);
% figure(2); contour(abs(in1))
phi = angle(in1);
F = abs(fft2(nodc)).*exp(1i*phi);
in2 = real(ifft2(F));
figure(2); imshow(in2, [])


%dark
% nodc = darklog - mean(darklog);
imd=~im;
nodc = imd-mean(imd);
darkpower = fftshift(fft2(nodc));
figure(3); imshow(abs(darkpower), []);
xlim([240, 280])
ylim([240, 280])
in1 = ifftshift(darkpower);
% figure(5); contour(abs(in1))
phi = angle(in1);
F = abs(fft2(nodc)).*exp(1i*phi);
in2 = real(ifft2(F));
figure(4); imshow(in2, [])