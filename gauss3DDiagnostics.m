function gauss3DDiagnostics(prefix, varargin)

optionalResults = '';

for i = 1:length(varargin)
    if strcmpi(varargin{i}, 'optionalResults')
        optionalResults = varargin{i+1};
    else
    end
end

[~,~,DropboxFolder,~, PreProcPath,...
    ~, Prefix, ~,~,~,~, ~] = readMovieDatabase(prefix, optionalResults);

DataFolder=[DropboxFolder,filesep,prefix];
load([DataFolder,filesep,'Spots.mat'], 'Spots');

ch = 1;
if iscell(Spots)
    Spots = Spots{ch};
end

sigmax = [];sigmay = [];sigmaz = [];
sigmaxy = []; sigmaxz = []; sigmayz = [];
amp = []; offset = []; x = []; y = []; z = [];
offx = []; offy = []; offz = [];

for frame = 1:length(Spots) 
    for spot = 1:length(Spots(frame).Fits)
        sp = Spots(frame).Fits(spot).fits3D;
        sigmax = [sigmax, sp(5)];
        sigmay = [sigmay, sp(8)];
        sigmaz = [sigmaz, sp(10)];
        sigmaxy = [sigmaxy, sp(6)];
        sigmaxz= [sigmaxz, sp(7)];
        sigmayz = [sigmayz, sp(9)];
        
        amp = [amp, sp(1)];
        offset = [offset, sp(11)];
        x = [x, sp(2)];
         y = [y, sp(3)];
          z = [z, sp(4)];
           offx = [offx, sp(12)];
         offy = [offy, sp(13)];
          offz = [offz, sp(14)];
          offxsq= [offx, sp(15)];
         offysq = [offy, sp(16)];
          offzsq = [offz, sp(17)];
          
           offxysq= [offx, sp(18)];
         offxzsq = [offy, sp(19)];
          offyzsq = [offz, sp(20)];
    end
    
end

figure()
subplot(7, 3, 1)
histogram(sigmax)
title('sigma x')
subplot(7, 3, 2)

histogram(sigmay)
title('sigma y')
subplot(7, 3, 3)

histogram(sigmaz)
title('sigma z')
subplot(7, 3, 4)

histogram(sigmaxy)
title('sigma xy')
subplot(7, 3, 5)

histogram(sigmaxz)
title('sigma xz')
subplot(7, 3, 6)

histogram(sigmayz)
title('sigma yz')

subplot(7, 3, 7)
histogram(x)
title('x')
subplot(7, 3, 8)
histogram(y)
title('y')
subplot(7, 3, 9)
histogram(z)
title('z')

subplot(7, 3, 10)
histogram(amp)
title('amplitude')

subplot(7, 3, 12)
histogram(offset)
title('offset')

subplot(7, 3, 13)
histogram(offx)
title('offset_x')


subplot(7, 3, 14)
histogram(offy)
title('offset_y')


subplot(7, 3, 15)
histogram(offz)
title('offset_z')

subplot(7, 3, 16)
histogram(offxsq)
title('offset_xsq')

subplot(7, 3, 17)
histogram(offysq)
title('offset_ysq')

subplot(7, 3, 18)
histogram(offzsq)
title('offset_zsq')

subplot(7, 3, 19)
histogram(offxysq)
title('offset_xysq')

subplot(7, 3, 20)
histogram(offxzsq)
title('offset_xzsq')

subplot(7, 3, 21)
histogram(offyzsq)
title('offset_yzsq')