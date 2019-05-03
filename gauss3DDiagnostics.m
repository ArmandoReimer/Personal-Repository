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

for frame = 1:length(Spots) 
    for spot = 1:length(Spots(frame).Fits)
        sp = Spots(frame).Fits(spot).fits3D;
        sigmax = [sigmax, sp(5)];
        sigmay = [sigmay, sp(8)];
        sigmaz = [sigmaz, sp(10)];
        sigmaxy = [sigmaxy, sp(6)];
        sigmaxz= [sigmaxz, sp(7)];
        sigmayz = [sigmayz, sp(9)];
    end
end

figure()
subplot(2, 3, 1)
histogram(sigmax)
title('sigma x')
subplot(2, 3, 2)

histogram(sigmay)
title('sigma y')
subplot(2, 3, 3)

histogram(sigmaz)
title('sigma z')
subplot(2, 3, 4)

histogram(sigmaxy)
title('sigma xy')
subplot(2, 3, 5)

histogram(sigmaxz)
title('sigma xz')
subplot(2, 3, 6)

histogram(sigmayz)
title('sigma yz')