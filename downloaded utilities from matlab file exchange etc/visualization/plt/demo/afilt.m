% afilt.m -----------------------------------------------------------------
%
% Displays the frequency response of the most common traditional analog filters.
% GUI controls are provided to adjust the most important filter parameters
% (Filter order, Cutoff frequency, & Passband/Stopband ripple). A pole/zero plot
% is also provided for the prototype filters (i.e. low pass with a cutoff
% frequency of 1 radian/sec). Both plots (especially the pole/zero plot) are
% easier to interpret with only one filter type enabled. To do this, right click
% on the "Elliptic" traceID (for example) in the black traceID block near the
% left edge of the figure. That will disable all traces on both plots except for
% the traces associated with the elliptic filter type.
%
% afilt creates these fourteen pseudo objects:
%  1.) a plot
%  2.) a cursor
%  3.) a grid
%  4.) an edit object (filter order)
%  5.) a popup (filter type)
%  6.) a popup (decades to display)
%  7.) a popup (number of points to display)
%  8.) a slider (passband ripple)
%  9.) a slider (stopband ripple)
% 10.) a slider (cutoff frequency)
% 11.) a slider (frequency 2)
% 12.) a secondary plot (pole/zero)
% 13.) a cursor for the 2nd plot
% 14.) a grid for the 2nd plot
%
% The first three three pseudo objects in this list are created by the first
% call to plt and the next  eight pseudo objects are created with eight
% additional calls to plt. And finally one more call to pltinit creates
% the last 3 pseudo objects.
%
% Although Matlab already has objects with similar names, these pseudo
% objects are different. They provide more utility and options. The
% pseudo objects 4 thru 7 listed above are grouped inside a parameter
% frame (a grey box implemented by using a Matlab axis object).
%
% There are two alternate versions of this application included in the demo
% folder (neither run by demoplt). The first is named afiltS.m and is a
% simplfied version of afilt (without some of the advanced features). The
% simplied version is used as the 2nd example in the "GUI programming with plt"
% section of the help file. The other alternate version (called afiltALT.m)
% differs primarily in the number of traces used. While afilt uses 10 traces
% (5 for magnitude and 5 for phase) afiltALT uses just 5 traces (on a single
% axes) to display both magnitude and phase for all 5 filter types. The trick
% to make this work is to use each trace to display both the magnitude and the
% phase information. Although I eventually decided that the 10 trace method was
% simpler, the alternate version is included since it illustrates a useful
% technique. Note that the tick marks are modified so that they read in degrees
% in the phase portion of the plot. Also the phase portion is highlighted with
% a gray patch to better separate it visually from the magnitude plot. afiltALT
% is shorter than afilt because it doesn't include the pole/zero plot and also
% (unlike afilt and afiltS) it takes advantage of some functions from
% from the signal processing toolbox.

% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

function afilt()
htxt = {'Select the filter order & type' 'in the parameter box above.' '' ...
        'Vary the ripple & frequency' ' parameters using the sliders.' .6+.62i 2i ...
        'pole/zero plot' 1.19+1.06i 'color' 'yellow' 2i ...
        'Prototype filters' '(low pass with' '1 rad/sec cutoff)' 1.16+.98i};

  p = {[ -0 .090 .105 .573 .760;   % plot 1 position
         -1 .015 .690 .065 .165;   %        traceID box
         -2 .008 .100 .043 .300;   %        menu box
        209 .486 .007 .020 .038;   %        y label
        206 .510 .006 .070 .040;   %        y cur left
        205 .585 .006 .070 .040;   %        y cur right
        322 -1.28 .45  0    0  ;   %        cursor ID
        323  1.03 .84  0    0  ];  %        right yaxis label
           [.012 .882 .185 .100];  % axis   position: Parameter frame
           [.060 .935 .030 .030];  % edit   position: filter order
           [.015 .710 .108 .200];  % popup  position: filter type
           [.174 .750 .026 .200];  % popup  position: # of decades
           [.156 .710 .058 .200];  % popup  position: # of points
           [.210 .946          ];  % slider position: Passband ripple
           [.350 .946          ];  % slider position: Stopband ripple
           [.490 .946          ];  % slider position: Cutoff frequency
           [.630 .946          ];  % slider position: frequency 2
           {-.09 .640          };  % text   position: eliptic transition ratio
       [ -3 .740 .050 .245 .814;   % plot 2 position (pole zero plot)
        221 .890 .940 .015 .040;   %        x label
        220 .890 .890 .015 .040;   %        y label
        219 .910 .940 .070 .040;   %        x cursor readout
        217 .910 .890 .070 .040]}; %        y cursor readout

  c = [000100; 010001; 000101; 010000; 206001];  c = [c; c]; % trace colors
  S.cfg = [which(mfilename) 'at'];  % use afilt.mat to save configuration data
  ftypes = {'Butter' 'Bessel', 'Cheby1'  'Cheby2' 'Elliptic'}; t10 = ones(1,10);
  lbx = 'radians/sec';  lby = {'dB' 'Phase \circ'};  yli = {[-90 60] [-1000 200]};
  typ = {'low pass' 'high pass' 'band pass' 'stop band'};  pts = 100*[1 2 4 8 16];
  s = plt(0,t10,'Right',6:10,'Options','logX I','closeReq',@cfg,'DualCur',-5,...
         'TraceID',ftypes,'Pos',[925 525],'Ylim',yli,'LabelX',lbx,'LabelY',lby,...
         'TIDcback',@clb,'xy',p{1},'TraceC',c,'+Ytick',-140:20:0,'-Ytick',[-180 0 180]);
  % create an axis as a frame for the 4 filter parameters 
  axes('units','norm','pos',p{2},'box','on','xtick',[],'ytick',[],'color','none',...
       'linewidth',3,'xcolor',[1 1 1]/2,'ycolor',[1 1 1]/2,'tag','frame');
  ax = get(s(1),'parent'); axes(ax); % reset the main plot axis as the active one
  S.n   = plt('edit',  p{3} ,[5 1 25],'callbk',@clb,'label','Or~der:');
  S.typ = plt('pop',   p{4} ,typ,'callbk',@clb,'index',3,'swap');
  S.dec = plt('pop',   p{5} ,1:5,'callbk',@clb,'index',3,'label','Decades:','hide');
  S.pts = plt('pop',   p{6} ,pts,'callbk',@clb,'index',2,'label','Points:', 'hide');
  S.Rp  = plt('slider',p{7} ,[ 2   .01   9],'Passband ripple', @clb);
  S.Rs  = plt('slider',p{8} ,[ 40  10  120],'Stopband ripple', @clb);
  S.Wn  = plt('slider',p{9} ,[.004 .001  1],'Cutoff frequency',@clb,5,'%4.3f 6 2');
  S.Wm  = plt('slider',p{10},[.03  .001  1],'frequency 2',     @clb,5,'%4.3f 6 2');
  S.etr = text(p{11}{:},'','units','norm','horiz','center','color',[.2 .6 1]);
  uc = [exp((0:.01:2)*pi*1j) NaN -99 99 NaN -99j 99j]; % unit circle and xy axes
  r = pltinit('Fig',gcf,0,ones(1,10),uc,'xyAXc',505000,'TRACEid',0,...
       'TRACEc',[c; 303000],'Styles','nnnnnnnnnn-','Markers','oooooxxxxxn',...
       'ENAcur',[t10 0],'LabelX','','LabelY','','Options','-All noBtn I','xy',p{12});
  S.tr = [s; r];  set(gcf,'user',S);              % save handles for callback
  set(findobj(gcf,'marker','x'),'MarkerSize',9);  % increase marker size for poles
  h = getappdata(gcf,'sli'); h(5:5:end) = [];
  set(h,'buttond','plt ColorPick;');
  for k = 1:length(h) setappdata(h(k),'m',{'backgr' h}); end;
  if exist(S.cfg) load(S.cfg);  % load configuration file if it exists -------------
                  plt('edit',S.n,'value', cf{1});  plt('pop',S.typ,'index',cf{2});
                  plt('pop',S.pts,'index',cf{3});  plt('pop',S.dec,'index',cf{4});
                  plt('slider',S.Rp,'set',cf{5});  plt('slider',S.Rs,'set',cf{6});
                  plt('slider',S.Wn,'set',cf{7});  plt('slider',S.Wm,'set',cf{8});
                  set(h,'background',     cf{9});  set(gcf,'position',     cf{10});
  end;
  clb;                                 % initialize plot
  axes(ax); plt('HelpText','on',htxt); % add help text
  plt cursor -1 updateH -1;            % center cursor
% end function afilt

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
  for e=1:5 af(e,ty,N,Wn,Rp,Rs,X,S.tr); end;     % set trace data
  plt('cursor',-1,'xlim',X([1 end]));            % set Xaxis limits for frequency response plot
  plt cursor -1 updateH;                         % update cursor
  h = find(get(S.tr(5),'y') < -Rs2);             % compute Elliptic transition ratio
  if     isempty(h)                    h = 0;    % no values of the trace in the stop band
  elseif (ty-2)*(ty-3)                 h = X(h(1))/Wn(1);  % here for low pass or stop band
  else    h = find(diff([h inf])>1);   h = Wn(1)/X(h(1));  % here for high pass or pass bande
  end;
  set(S.etr,'string',prin('Elliptic ~, transition ~, ratio: ~, %5v',h));
  x = -.1;  y = x;
  t = plt('show');  t = t(find(t<6));  plt('show',[t t+5 t+10 t+15 21]);  % for traceID callback
  for k = S.tr(11:20)'
     v = get(k,'vis'); % find smallest x and y values for all the visible traces
     if v(2)=='n'  x = min([x get(k,'x')]);  y = min([y get(k,'y')]); end;
  end;
  x = [1.05*x -.2*x];  y = 1.05*y;  y = [y -y]; % x & y limits to insure that we see all the roots
  dx = diff(x);  dy = diff(y);  r = 1.89;       % r is vert axis length divided by horiz axis length
  if dy > r*dx  d = dy/r-dx;  x = x + [-d d]/2; % zoom out the x axis to equalize the aspect ratio
  else          d = dx*r-dy;  y = y + [-d d]/2; % zoom out the y axis to equalize the aspect ratio
  end;
  plt('cursor',get(get(S.tr(end),'parent'),'user'),'xylim',[x y]); % set pole/zero plot axis limits
  plt('HelpText','off');
% end function clb

function cfg() % write configuration file
  S = get(gcf,'user');  sli = findobj(gcf,'style','slider');
  cf = { plt('edit',S.n);       plt('pop',S.typ);
         plt('pop',S.dec);      plt('pop',S.pts);
         plt('slider',S.Rp);    plt('slider',S.Rs);
         plt('slider',S.Wn);    plt('slider',S.Wm);
         get(sli(1),'backgr');  get(gcf,'position') };
  save(S.cfg,'cf');
% end function cfg

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

function af(e,ty,N,Wn,Rp,Rs,X,g)  % ------------ compute analog filter response & set trace data ----------------
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
  H = X*j; H = polyval(num,H)./polyval(den,H); e = [e e+5];       % calculate transfer function
  set(g(e),'x',X,{'y'},{20*log10(abs(H)); angle(H)*180/pi});      % set traces (magnitude & phase)
  set(g(e+10),{'x'},{real(z); real(p)},{'y'},{imag(z); imag(p)}); % set traces (zero/pole)
% end function af
