function placefig(fig,m,n,k, forcedW, forcedH, setVirtualScreenSize, ws,hs)
% PLACEFIG(fh,m,n,k,varargin) - puts figure fh in position k of a (m x n) array of figures on the screen.
% 
%   m x n picture matrix, set at location k, row-wise-counting
%         k (m=2,n=3)   x(n)        y(m)
%         1  2  3       1  2  3    1   1   1
%         4  5  6       1  2  3    2   2   2
% 
%   Figure is resized to fit in the viewport at the indicated location k
%   Actual screen size and possible OS (windows) scaling is calculated
% 
%   PLACEFIG([],[],[],[], [], [], 1, w, h)
%   Set virtual screen size to w x h pixels. Call it before the ordinary placefig command, 
%   to use only a portion of the screen for plotting
% 
%   EXAMPLE: put figure to cover top half of the screen
%   figure(31);
%   placefig(31, 2,1,1);
% 
%   EXAMPLE: put figure to cover top/left quarter of the screen
%   figure(31);
%   placefig(31, 2,2,1);
% 
%   EXAMPLE: grid of 2x3 figuresfill up first 4
%   figure(31);figure(32);figure(33);figure(34);
%   placefig(31, 2,3, 1);
%   placefig(32, 2,3, 2);
%   placefig(33, 2,3, 3);
%   placefig(34, 2,3, 4);
% 
%   EXAMPLE: force figure size in pixels
%   figure(31);
%   placefig(31, 2,2,1,800,600)
% 
%   EXAMPLE: keep original figure size, yet put them on a grid
%   figure(31);figure(32);figure(33);figure(34);
%   placefig(31, 2,3, 1j);
%   placefig(32, 2,3, 2j);
%   placefig(33, 2,3, 3j);
%   placefig(34, 2,3, 4j);
% 
%   rev.3, Massimo Ciacci, September 19, 2019
% note: better to place the figure immediately after creation, before plotting onto it, it works faster.
% 
% note: when you see that figures get in the wrong places, restart Matlab, 
% since undocking the laptop can cause issues 
% both in set('position') and get(0,'screensize') in Windows 10
% 
persistent kFix
persistent virtualScreenSize

if isempty (kFix)
    kFix=1;
    virtualScreenSize.isset = false;
    virtualScreenSize.w     = 0;
    virtualScreenSize.h     = 0;
end

% argument check
if ~ishandle(fig)
    return;
end
if isempty(fig) && nargin<=6
    return;
end

% handle position counter when not explicitly given
if nargin == 3
    k    = kFix;
    kFix = kFix+1;
end

if nargin >= 6
    if ~isempty(forcedW)
        forceSize = true;
        origfigpos=get(fig,'position');
        if forcedW < 0
            forcedW = origfigpos(3);
            forcedH = origfigpos(4);
        end
    else
        forceSize = false;
    end
else
    forceSize = false;
end

if nargin == 9
    if setVirtualScreenSize
        virtualScreenSize.isset = true;
        virtualScreenSize.w     = ws;
        virtualScreenSize.h     = hs;
        return
    end
end


%% a fixed virtual screen is useful e.g. when need to generate same plots on different PCs
% PLOT_REUSE = 0;
% if PLOT_REUSE
%     % freeze figure sizes to facilitate reuse across different platforms
%     virtualScreenSize.isset = true;
%     virtualScreenSize.w     = 1920;
%     virtualScreenSize.h     = 1200;
% end
% % virtualScreenSize.w     = 1560;
% % virtualScreenSize.h     = 976;


if ~isempty(fig)
    figure(fig);
    set(fig,'units','pixels');
end

keepSize = 0;
if imag(k) ~=0 && real(k) ==0
    k = imag(k);
    keepSize = 1;
end

k = mod(k-1,m*n)+1;

x = mod(k-1,n)+1; %x index
y = ceil(k/n);


% dataCell         = num2cell(get(0,'ScreenSize'));
% [u1 u2 truew trueh] = deal(dataCell{:});
% sxsyswsh1  = get(0,'ScreenSize');
sxsyswsh2  = getScreenSizeFunc();
truew = sxsyswsh2(3);
trueh = sxsyswsh2(4);




OverRule_v_size_if_virtual_too_big = 1; % let true vertical size make its job
                                        % nicer layout, but no guarantee of doc portability
% OverRule_v_size_if_virtual_too_big = 0; % FREEZE figure sizes (doc portability)

if OverRule_v_size_if_virtual_too_big
    %% virtualScreenSize MUST be smaller than true screen else figures will start bouncing
    virtualScreenSize.h = min(virtualScreenSize.h,trueh);
end
 

if (virtualScreenSize.isset)
    w                = virtualScreenSize.w;
    h                = virtualScreenSize.h;
else
    w                = truew;
    h                = trueh;    
end

botMargin =  48 + 96; %% leave enough margin, e.g. with VirtualBox in windowed mode weird stuff...
topMargin =  80;
lftMargin =  4;
rgtMargin =  4;
disth     =  0;  %make sure  outsideTop does not heppen or this will be ignored !
distw     =  0; %in Win10 no need for this margin
% WinTitleHeight = 10; %let it happen, maximize figure size



hTot      = h-botMargin-topMargin - (m-1)*disth;
wTot      = w-lftMargin-rgtMargin - (n-1)*distw;

hFig = floor(hTot/m) ;
wFig = floor(wTot/n) ;
hFig2= hFig +disth;
wFig2= wFig +distw;


%original figure size
fig_size_xyzh = get( fig, 'Position' );
figw = fig_size_xyzh(3);
figh = fig_size_xyzh(4);

diffh = 0;
if (forceSize)
    diffh = max(hFig-forcedH,0); %if height smaller get diff to align on top
    wFig = forcedW;
    hFig = forcedH;
end


if keepSize
    xbl_ybl_wFig_hFig=get(fig,'Position');
    wFig = xbl_ybl_wFig_hFig(3);
    hFig = xbl_ybl_wFig_hFig(4);
end

%   x             y             k (m=2,n=3)
%
%   1  2  3       1   1   1     1  2  3    ^
%                                          | hTot
%   1  2  3       2   2   2     4  5  6    v
%

% mxn = 3x2
% k = 3
% ==> x = 1, y=2
% 
% x = counter down
% y = counter right
% 
% 
% +-------------+--------------+ ---
% |                               ^
% |                               | h (also virtual)
% +   +---------+                 |
% |   |         |                 |
% |   |         |                 |
% +   +---------+                 |
% |                               |
% |                               |
% +                               |
% ||   Bot Margin                 v
% +                              -- 

yBotLeftFig = (m-y)*hFig2+botMargin + diffh; %use calculated Fig sizes here
xBotLeftFig = (x-1)*wFig2+lftMargin; %use calculated Fig sizes here

yTop        = yBotLeftFig+hFig;
% outsideTop  = yTop + topMargin + WinTitleHeight - trueh;
outsideTop  = yTop + topMargin - trueh;
if (outsideTop>0)
    yBotLeftFig = yBotLeftFig-outsideTop;
end

xRight        = xBotLeftFig+wFig;
outsideRight  = xRight  - truew;
if (outsideRight>0)
    xBotLeftFig = xBotLeftFig-outsideRight;
end


% %   pos = get(fig,'position');
% %   fr  = getframe(fig);  % (1)  this can cause limits to change if visible = off !
% %                         % (2)  this is extremely slow (150ms) !
% %   q   = size(fr.cdata); actualSizePixels=[q(2),q(1)];
% %   A   = mean(actualSizePixels./pos(3:4));

A  = get_OS_pixel_ScalingFactor();
set(fig,'visible','off'); %set(gcf,'Resize','off')
% try
    set(fig,'position',[xBotLeftFig, yBotLeftFig, wFig, hFig]/A);
% catch
%     keyboard
% end
set(fig,'visible','on');

% drawnow %this messes up things big time if done in invisible mode!


function A = get_OS_pixel_ScalingFactor()
% Since ML 2016, screen size is 'kind of wrong', AND set(gcf,'position') is also 'kind of wrong'...
% with this I mean they both go via OS and call pixels things which will be scaled up 150% or 125%
% depending on the OS settings.
% 
% The two 'kind of wrong' do not cancel out, strange enough
% get(0,'screensize')               --> 1.25X smaller than real
%                                   --> smaller figure desired size
%                                       which kind of goes the right way           
% set(gcf,'position',[x0 y0 dx dy]) --> 1.25x larger image
% Still, the figure will go out of screen.. (go figure)
%
% Workaround : check OS scaling factor by comparing getframe cdata size vs get(gcf,'position')
% 1 - check current figure 'position' which reports some desired size x, not the actual one in pixels
%     pos = get(gcf,'position')
% 2 - measure true pixel size xP from frame cdata, 
%     fr=getframe(gcf);q=size(fr.cdata); actualSize=[q(2),q(1)]
% 3 - calc scale factor A = xP/pos > 1
% 4 - set figure position with xP/A which will result in true size xP
% e.g.
%     figure(1)
%     pos = get(gcf,'position');
%     fr  = getframe(gcf);  % (1)  this can cause limits to change if visible = off !
%                           % (2)  this is extremely slow (150ms) !
%     q=size(fr.cdata); actualSizePixels=[q(2),q(1)];
%     A = mean(actualSizePixels./pos(3:4));
%     posDst=[100,100,1800,900];
%     set(gcf,'position',posDst/A)
persistent Aprev
if isempty(Aprev)
    ftmp   = figure(); set(ftmp,'visible','off');
    pos    = get(ftmp,'position'); % windows pixels (larger)
    fr     = getframe(ftmp); %true pixels, Takes 210 ms on a 16 core Ryzen 7
    q      = size(fr.cdata); actualSizePixels=[q(2),q(1)];
    close(ftmp);
    Aprev   = mean(actualSizePixels./pos(3:4));    
end
A = Aprev;
