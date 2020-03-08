%define
  %pi = 3.1415926;    %e = 2.7182818284590;
  %big = 1e20 * pi * e;
  %a = 3;
  %car = 9999;
  %i = -((2.0 - 1e4 + car) * a + 1) * 10 * 10 / 2;
  %b = [2*3+a, 4*5, 6*7+10, car];
  %x = [10.1, 10.2, 0.00001*a, 1e4];     % note that the leading 0 is needed
  %v = [b(2), x(3), b(2)*x(3)];
  %labels = ['Label01'; 'Label02'; 'Label03'; 'Label04'];
  %bx = b + x;  % this will work, but next line will be much more efficient
  %bxx = [b(1)+x(1), b(2)+x(2), b(3)+x(3), b(4)+x(4)]; % see expansion of this
  %EMPTY = isempty;                % synonym for isempty function
  %NONE( = isempty(;               % another synonym for isempty function
  %PHASE( = (180/pi) * angle(;     % phase of complex argument in degrees
  %InputGain( = siglab('InpGain',; % synonym for siglab input gain call
%end_define

%  yy = big;  ii = i;
   yy = 8.539734077001e+20;  ii = -200;

%  bbb = b;   bbb = b(4) * b(1);
   bbb = [9,20,52,9999];   bbb = 89991;

%  xx = x(1) + aaa + x(3) + x(2);   xx = x(1) + x(3) + x(2);
   xx = 10.1 + aaa + 3e-05 + 10.2;   xx = 20.30003;

%  x4 = v * v(3);
   x4 = [20,3e-05,0.0006] * 0.0006;

%  ebx = bx;
   ebx = [9,20,52,9999] + [10.1,10.2,3e-05,10000];
   
%  ebxx = bxx;
   ebxx = [19.1,30.2,52.00003,19999];

%  ee = 2e3 + 2.0e-2 * 3.e2;
   ee = 2006;

%  xlabel([labels(2),labels(4)]);
   xlabel([ 'Label02', 'Label04']);

%  if q1 == q2  ex1 = 3/4; else ex1 = 4/3; end;
   if q1 == q2  ex1 = 0.75; else ex1 = 1.333333333333; end;

%  if EMPTY(wg) wg = 1;   if NONE(wg) wg = 1;
   if isempty(wg) wg = 1;   if isempty(wg) wg = 1;

%  deg = PHASE(xx + yy*j);   InputGain(Chan,Level);
   deg = (180/3.1415926) * angle(xx + yy*j);   siglab('InpGain',Chan,Level);
