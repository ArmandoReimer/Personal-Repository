% afiltS.m         Some of the advanced features of afilt.m were removed to create this
%                  simplified version which is suitable to be used as the 2nd example
%                  in the "GUI programming with plt" section of the plt help file.
function afiltS()
  p = {[.125 .105 .850 .760];  % plot    position
       [.100 .882 .235 .100];  % axis    position: Parameter frame
       [.165 .935 .040 .030];  % edit    position: filter order
       [.110 .710 .100 .200];  % popup   position: filter type
       [.310 .750 .024 .200];  % popup   position: # of decades
       [.287 .710 .054 .200];  % popup   position: # of points
       [.350 .946 .150     ];  % slider  position: Passband ripple
       [.510 .946 .150     ];  % slider  position: Stopband ripple
       [.670 .946 .150     ];  % slider  position: Cutoff frequency
       [.830 .946 .150     ]}; % slider  position: frequency 2
  typ = {'low pass' 'high pass' 'band pass' 'stop band'};  pts = 100*[1 2 4 8 16];
  ftypes = {'Butter' 'Bessel', 'Cheby1'  'Cheby2' 'Elliptic'};
  S.tr = plt(0,zeros(1,5),'TraceID',ftypes,'Options','logX','xy',p{1},...
             'Ylim',[-80 5],'LabelX','radians/sec','LabelY','dB');
  axes('units','norm','pos',p{2},'box','on','xtick',[],'ytick',[],'color','none',...
       'linewidth',3,'xcolor',[1 1 1]/2,'ycolor',[1 1 1]/2,'tag','frame');
  axes(get(S.tr(1),'parent')); % reset the main plot axis as the active one
  S.n   = plt('edit',  p{3} ,[5 1 25],'callbk',@clb,'label','Or~der:');
  S.typ = plt('pop',   p{4} ,typ,'callbk',@clb,'index',3,'swap');
  S.dec = plt('pop',   p{5} ,1:5,'callbk',@clb,'index',3,'label','Decades:','hide');
  S.pts = plt('pop',   p{6} ,pts,'callbk',@clb,'index',2,'label','Points:', 'hide');
  S.Rp  = plt('slider',p{7} ,[ 2   .01   9],'Passband ripple', @clb);
  S.Rs  = plt('slider',p{8} ,[ 40  10  120],'Stopband ripple', @clb);
  S.Wn  = plt('slider',p{9} ,[.004 .001  1],'Cutoff frequency',@clb,5,'%4.3f 6 2');
  S.Wm  = plt('slider',p{10},[.03  .001  1],'frequency 2',     @clb,5,'%4.3f 6 2');
  set(gcf,'user',S);  clb;    % save parameters for clb, and initialize the plot
% end function afiltS

function clb() % callback function for all objects
  S = get(gcf,'user');
  ty = plt('pop',S.typ);                         % get filter type index (1:4 = low,high,band,stop)
  N   = plt('edit',S.n);                         % get filter order
  dec = plt('pop',S.dec);                        % get number of decades to plot
  pts = str2num(get(S.pts,'string'));            % get # of points to plot
  X   = logspace(-dec,0,pts);                    % X-axis data (radians/sec)
  Wn  = plt('slider',S.Wn);                      % get filter freq
  Rp  = plt('slider',S.Rp);                      % get passband ripple
  Rs  = plt('slider',S.Rs); Rs2 = max(Rp+.1,Rs); % get stopband ripple (must be > passband)
  if ty>2 Wn = [Wn plt('slider',S.Wm)];          % get frequency 2
          plt('slider',S.Wm,'visON');            % make frequency 2 slider visible
  else    plt('slider',S.Wm,'visOFF');           % make frequency 2 slider invisible
  end;
  for k=1:5 set(S.tr(k),'x',X,'y',af(k,ty,N,Wn,Rp,Rs,X)); end; % set trace data
  plt('cursor',-1,'xlim',X([1 end]));                          % set Xaxis limits
% end function clb

function v = vrt(u,ineps,mp)
  [s,c] = ellipj(u,mp);  v = abs(ineps - s/c);

function r = krt(m,krat)
  m = min(1,max(m,0));
  if abs(m) > eps & abs(m)+eps < 1   k = ellipke([m,1-m]);
                                     r = abs(k(1)./k(2) - krat);
  elseif abs(m) <= eps               r = krat;  % m==0
  else                               r = 1e20;  % m==1
  end;

function f = fac(n)  % since factorial does not accept a vector before Matlab 7
  for k=1:length(n)  f(k) = factorial(n(k)); end;

function H = af(e,ty,N,Wn,Rp,Rs,X) % ------ compute analog filter response --------------------------------------
  if N==1 & e==5  e=3; end;                                % ellip degenerates to cheby1 for 1st order
  if ty<3 Wn = Wn(1);                                      % low pass or high pass
  else    bw = diff(Wn);  Wn = sqrt(prod(Wn));  q = Wn/bw; % bandpass or stopband
  end;
  k = 1;  z = [];  rp2 = 10^(.1*Rp)-1;  rp = sqrt(rp2);  rs = sqrt(10^(.1*Rs)-1); % passband/stopband ripple
  switch e
    case 1, p = exp(j*(pi*(1:2:N-1)/(2*N) + pi/2));                          % butterworth -- from Jack Little --
            p = [p; conj(p)];  p = p(:);  if rem(N,2) p = [p; -1];  end;
    case 2, m = N:-1:0;  p = fac(2*N-m)./(2.^(N-m).*fac(m).*fac(N-m));       % besself ------ from Paul Mennen --
            p = roots(p)/p(end)^(1/N);
    case 3, mu = asinh(1/rp)/N;  p = exp(j*(pi*(1:2:2*N-1)/(2*N) + pi/2)).'; % cheby1 ------- from Jack Little --
            p = sinh(mu)*real(p) + j*cosh(mu)*imag(p);
            if ~rem(N,2) k = sqrt((1+rp2)); end;
    case 4, mu = asinh(rs)/N;  p = exp(j*(pi*(1:2:2*N-1)/(2*N) + pi/2)).';   % cheby2 ------- from Jack Little --
            if rem(N,2) z = j ./ cos([1:2:N-2 N+2:2:2*N-1]*pi/(2*N))';  N=N-1;
            else        z = j ./ cos((1:2:2*N-1)*pi/(2*N))';
            end;
            t = [1:N/2; N:-1:N/2+1];  z = z(t(:)); % Organize complex pairs
            p = 1 ./ (sinh(mu)*real(p) + j*cosh(mu)*imag(p));
    case 5, k1 = rp/rs;  k1p = 1-k1^2;                                       % ellip -------- from Loren Shure --
            if abs(1-k1p) < eps krat = 0;
            else                capk1 = ellipke([k1^2,k1p]);
                                krat = N*capk1(1)/capk1(2); % krat = K(k)/K'(k) -- find relevant k
            end;
            fopt = optimset('maxfunevals',250,'maxiter',250,'display','none');
            m = fminsearch(@krt,.5,fopt,krat);            % find elliptic parameter m so that K(m)/K'(m) = krat
            capk = ellipke(m);  jj = (1-rem(N,2)):2:N-1;  % find zeros (purely imaginary)
            [s,c,d] = ellipj(jj*capk/N,m*ones(size(jj))); % s is Jacobi elliptic function sn(u)
            is = find(abs(s) > eps);  z = j ./(sqrt(m)*s(is));  z = [z(:); conj(z(:))];
            r = fminsearch(@vrt,ellipke(1-m),fopt,1/rp,k1p);  v0 = capk*r/(N*capk1(1));
            [sv,cv,dv] = ellipj(v0,1-m);  p = -(c.*d*sv*cv + i*s*dv)./(1-(d*sv).^2);  p = p(:);
            if rem(N,2) pp = 1:size(p,1);                 % odd N - one real pole
                        pp(find(abs(imag(p)) < eps*norm(p))) = [];  p = [p; conj(p(pp))];
            else        p = [p; conj(p)];  k = sqrt((1+rp2));  % gain fix for even order
            end;
  end; % end switch e
  [a,b,c,d] = zp2ss(z,p,real(prod(-p)/prod(-z))/k);       % Transform to state-space
  m = size(b,2);  [x,y] = size(c);  ey = eye(y);  v = 0*c;  zy = zeros(y);  zym = zeros(y,m);
  switch ty
    case 1,  a = a*Wn;                   b = b*Wn;                                                    % low pass
    case 2,  d = d-c/a*b;  c = c/a;      b = -Wn*(a\b);           a =  Wn*inv(a);                     % high pass
    case 3,  a = Wn*[a/q ey; -ey zy];    b = Wn*[b/q; zym];       c = [c v];                          % band pass
    case 4,  d = d-c/a*b;  c = [c/a v];  b = -[Wn/q*(a\b); zym];  a = [Wn/q*inv(a) Wn*ey; -Wn*ey zy]; % band stop
  end;
  den = poly(a);                                                 % caclulate num/den polynomials
  if e==1 | e==3 num = poly(a-b*c)+(d-1)*den;                    % numerator polynomial (for butter & cheby1)
  else           [Z,P,k] = ss2zp(a,b,c,d);   num = k * poly(Z);  % for other filter types use this alternate method
                 num = [zeros(1,length(den)-length(num))  num];
  end;
   H = j*X;  H = polyval(num,H)./polyval(den,H);                 % calculate transfer function
   H = 20*log10(abs(H));                                         % return as magnitude (dB)
% end function af
