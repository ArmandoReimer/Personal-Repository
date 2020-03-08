function [matout] = boxconv(matin,lenc,lenr)
% [matout] = boxconv(matin,lenc,lenr)
% Boxcar window convolution, like
% Matlab matout=conv2(matin,ones(lenc,lenr),'same')
% It uses FFT, then it is much faster as the windows get large.
%
% Inputs:
%   matin: a vector or a matrix to be averaged
%   lenc:  averaging window size in column direction
%   lenr:  averaging size in row direction
%  Output:
%   matout: the averages result, same size as matin
%
% See also: conv2
% Example
%  x=randn(900,500);
%    tic;y1 = conv2(x,ones(70,40),'same');toc
%    tic;y2 = boxconv(x,70,40);toc
%    err=y1-y2; norm(err,2)
%
% Andrea Monti Guarnieri

[Nr, Nc]=size(matin);
if  ((Nr == 1 && lenc ~= 1) || (Nc == 1 && lenr ~= 1))
    error('2D convolution is not applicable for 1D signals') ;
end

if (lenr == 1 && lenc == 1)
    matout = matin;
    return
end

% For small kernels boxconv quite less accurate than conv2
if islogical(matin)
    matout = conv2(single(matin), ones(lenc,lenr,'single'), 'same');
else
    if lenr > 20 && lenc > 20
        matout = FastFFTSmooth( matin, lenc, lenr);
    else
        matout = conv2(matin, ones(lenc,lenr,class(matin)),'same');
    end
end
end


function matout = FastFFTSmooth( matin, wsc, wsr, win )
%function matout = FastSmooth( matin, wsc, wsr[, win])
%   Fast smoothing, 'win' window
%   matin: input matrix
%   wsc: window_lengh along columns
%   wsr: window_lengh along rows
%   win: pointer to window function, or @(x) (rectwin(x))
%   matout: output smoothed matrix

% keep memory of the last filter spectrum
persistent flow wsr_old wsc_old nr_old nc_old nrp ncp

if ndims(matin) ~= 2
    warning('Only 2D matrixes');
    return
end

if nargin < 4
    win =  @(x) (rectwin(x));
end
[nc, nr]=size(matin);

if isempty(flow) || wsc_old ~= wsc || wsr_old ~= wsr || nr_old ~= nr || nc_old ~= nc
    % compute again the filter
    fpresc = win(wsc);
    fpresr = win(wsr)';
    tmp = fpresc*fpresr;
    % add border for filter and find optimal fft size
    ncp = nextpow2357(nc+wsc);
    nrp = nextpow2357(nr+wsr);
    % do fft
    flow = zeros(ncp,nrp,'like',matin);
    flow(1:wsc,1:wsr)=tmp;
    % circulate for zero phase
    wsc2 = (wsc-rem(wsc,2))/2;
    wsr2 = (wsr-rem(wsr,2))/2;
    tmp =circshift(flow,-wsc2,1);
    flow = circshift(tmp,-wsr2,2);
    % transform filter
    flow =fft2(flow);
    % update status
    wsc_old = wsc; wsr_old=wsr; nr_old=nr; nc_old=nc;
end

% do filter in frequency domain
matfil = ifft2(fft2(matin,ncp,nrp).*flow);
% copy to output the valid elements
matout = matfil(1:nc,1:nr);
if isreal(matin) && ~isreal(matout)
    matout=real(matout);
end
end

function [m,vet_div,vet_pow]=nextpow2357(n)
% function [m,vet_div,vet_pow]=nextp2357(n)
% Find the closest power of 2,3,5,7,11,13 >= n
%  to be used for optimal FFT size
% Input:
%   n is the integer number
% Output:
%   m is the closest power, 
%   vet_div the array: [2 3 5 7 11 13]
%   vep_pow the array with the exponents
%   so that m = vet_div.^vet_pow
%
% Example:  
%vetp = randn(2003,2003);
%tic; V=fft2(vetp); toc;
%tic; V=fft2(vetp,nextpow2357(size(vetp,1)),nextpow2357(size(vetp,2))); toc
%	
% Andrea Monti-Garnieri
%

if ~isscalar(2)
	error('N should be scalar');
end

vet_div = [2 3 5 7 11 13];
tmp2 = n;
tmp = tmp2;
while tmp > 1  % find the exact divisor
  vet_exp = [0 0 0 0 0 0];
  tmp = tmp2;
  while tmp>1   % I did not find an exact divisor for tmp
   ind = rem(tmp,vet_div)==0;  
   if ~any(ind)       % the is no more a divisor (number is bad)
       tmp2 = tmp2+1; % try another one
       break
   else
        vet_exp = vet_exp+ind;
        tmp = tmp/prod(vet_div.^ind);
   end
  end
end
vet_pow = vet_exp;
m = tmp2;
end
 

