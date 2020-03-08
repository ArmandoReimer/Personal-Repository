function sum5s(Action);  % Start program by typing "sum5s" (no arguments)
%
% sum5s.mi               Paul Mennen (paul@mennen.org)
%
% ----------------------------------------------------------------------------
%         GUI programming example using MPP (the Matlab PreProcessor)
% -----------------------------------------------------------------------------
%
% This example shows how you can simplify a MatLab GUI program by using the MPP
% preprocessor. In this program, an approximation to a square wave is computed
% by adding together up to 5 sine waves, which is then continuously plotted
% with varying amplitude after the run button is clicked.
%
% By defining constants for the GUI properties and the unchanging parts of the
% GUI calls, the code for the creation of objects becomes more concise and
% readable. The biggest improvement in readability comes from defining symbols
% for each handle. Defining each handle constant as 1 plus the previous handle
% makes it easy to insert new handles without manually editing all the numbers.
% There is no compile or run time penalty for this, since MPP reduces these to
% a single constant. Likewise all the 4 element position vectors are written
% in terms of previously defined height and width parameters and are reduced
% to simple vector constants by the preprocessor. Readability is also enhanced
% by using the mpp definitions for the GUI controls such as FIGUR(, FRAME(,
% BUTTON(, SLIDER( and TEXT(. These definitions (similar to macros) create new
% function names which keep the source concise by hiding unimportant detail.
% In a large GUI application you may want to move the define section to one or
% more include files so they can be included with each module.

% ---------------------------------------------------------------------------

%define
  %FigTITLE = $$FileName$.m:  Square wave from sines $$;       % figure title 
  %NOF = 5;                   % max number of frequencies/amplitudes allowed
  %EVALerr = '''err''';       % eval error returns 'err'
  %BEEP = fprintf(1,char(7)); % beep to signal user entry error
  %DEFAULTspd = 6;            % startup value for speed control
  %SPEEDadj = 3000;           % adjust to a reasonable speed
  %Vrun = 1;                  % displays updating
  %Vstop = 0;                 % displays not updating
  %Vquit = -1;

% GUI objects and properties ------------------------------------------------
  %HIDE       = 'visible','off';
  %SHOW       = 'visible','on';
  %ENABLE     = 'enable','on';
  %DISABLE    = 'enable','off';
  %LEFTalgn   = 'HorizontalAlignment','Left';
  %CENTERalgn = 'HorizontalAlignment','Center';

  %COLORfig  = 'Color',[.25 .25 .25];             % figure background color
  %COLORfrm  = 'BackgroundColor',[0 .5 .5];       % frame background color
  %COLORttl  = 'BackgroundColor',[.64 .78 .94];   % frame title background
  %COLORtxt  = 'BackgroundColor',[.5 .5 .5];      % label background color
  %COLORedt  = 'BackgroundColor',[.75 .75 .75];   % edit box background color
  %COLORpup  = 'BackgroundColor',[.75 .86 .75];   % popup background color
  %COLORplt  = 'Color','black';                   % plot background color
  %COLORtrc  = 'Color','green';                   % trace color
  %COLORxy   = 'Xcolor','white','Ycolor','white'; % xy axis colors
  
  %FIGUR(  = figure(COLORfig,'NumberTitle','off','Menu','none',...
%               'DoubleBuf','on','Resize','off','Position',
  %AXISxy( = axes(COLORplt,COLORxy,'Units','Pixels','DrawMode','fast',...
%               'Box','on','NextPlot','add','Position',
  %LINE(   = line(COLORtrc,'EraseMode','Normal',
  %BUTTON( = uicontrol('Style','Pushbutton','Position',
  %SLIDER( = uicontrol('Style','Slider','Position',
  %FRAME(  = uicontrol('Style','Frame',COLORfrm,'Position',
  %FTITLE( = uicontrol('Style','Text',COLORttl,CENTERalgn,'Position',
  %TEXT(   = uicontrol('Style','Text',COLORtxt,LEFTalgn,'Position',
  %POPUP(  = uicontrol('Style','Popup',COLORpup,'Position',
  %EDIT(   = uicontrol('Style','Edit',COLORedt,'Position',
% ACTIONS -------------------------------------------------------------------
  %ACTrun    = 'Callback','sum5s run';
  %ACTstop   = 'Callback','sum5s stop';
  %ACTopen   = 'Callback','sum5s open';
  %ACTsave   = 'Callback','sum5s save';
  %ACTtoggl1 = 'Callback','sum5s toggl1';
  %ACTplus   = 'Callback','sum5s plus';
  %ACTminus  = 'Callback','sum5s minus';
  %ACTxlm    = 'Callback','sum5s xlm';
  %ACTylm    = 'Callback','sum5s ylm';
  %ACTspd    = 'Callback','sum5s spd';
  %ACTspde   = 'Callback','sum5s spde';
  %ACTamp    = 'Callback','sum5s amp';

% Handle definitions -----------------------------------------------------
  %FILE=1;                   % File menu
  %FOPEN; %FSAVE;             % File submenus 1&2 (Open & Save)
  %TOGGL1;                   % Toggle frame 1 menu
  %HELP;                     % Help menu
  %AXIS1;                    % Plot axis 1
  %PLOT1;                    % xy Plot 1 (line)
  %PLUS; %MINUS;              % + and - buttons
  %RUN; %STOP;                % run, stop buttons
  %FRM1; %FRM1T;              % Frame 1, Frame 1 title
  %XLIML; %XLIM;              % Xaxis limit Popup label, Xaxis limit Popup
  %YLIML; %YLIM;              % Yaxis limit label, Yaxis limit edit box
  %SPEED; %SPEEDL; %SPEEDE;    % Speed slider, Speed label, Speed edit box
  %AMP1;%AMP3;%AMP5;%AMP7;%AMP9; % Amplitude (Freq = 1,3,5,7,9)
  %LBL1;%LBL3;%LBL5;%LBL7;%LBL9; % Label 1,3,5,7,9
  %LASTh;                    % highest index in hh()
  
% ---------------------- control positioning ----------------------
  %VS = 25;   %HS = 5;     % Vertical/Horizontal spacing between controls
  %WIDe = 48; %WIDl = 80;  % Width: edit boxes, labels
  %WIDb = 40; %WIDf = 50;  % Width: buttons, Fstart/Fstop labels
  %HIGt = 16; %HIGb = 17;  % Height: text, buttons
  %X0   = 7;              % x pos, Frame 1 & 2
  %X1   = X0+HS;          % x pos, Labels
  %X2   = X1+WIDf+HS;     % x pos, Amplitude values
  %X4   = X1+WIDl+HS;     % x pos, Edit boxes
  %X5   = 470;            % x pos, Control group frame (Run/Stop)
  %X6   = X5 + HS;        % x pos, Run button
  %X7   = X6 + WIDb + HS; % x pos, Stop button
  %Y2   = 20;             % y pos, Bottom Amplitude
  %Y3   = Y2 + VS;        % y pos
  %Y4   = Y3 + VS;        % y pos
  %Y5   = Y4 + VS;        % y pos
  %Y6   = Y5 + VS;        % y pos, Top Amplitude
  %Y7   = Y6 + VS;        % y pos, +/- buttons
  %Y8   = Y7 + 70;        % y pos, speed slider
  %Y9   = Y8 + HIGt;      % y pos, speed slider label
  %Y10  = Y9 + VS;        % y pos, Y axis edit box
  %Y11  = Y10 + VS;       % y pos, X axis popup

  %posFIG  = [160,10,580,340];         % figure postion
  %posAX1  = [X4+80,55,390,270];       % axis position
  %posFRM1 = [X0,Y8-13,143,Y11-Y8+60]; % Frame 1 position
  %posFR1L = [X0+1,Y11+30,141,HIGt];   % Frame 1 label position
  %posFRM2 = [X0,Y2-13,116,Y7-Y2+61];  % Frame 2 position
  %posFR2L = [X0+1,Y7+31,114,HIGt];    % Frame 2 label position
  %posFRM3 = [X5,0,2*WIDb+3*HS,30];    % Run/Stop frame position
  %posRUN  = [X6,5,WIDb,HIGb];         % run button position
  %posSTOP = [X7,5,WIDb,HIGb];         % stop button position
  %posPLUS = [X1+2,Y7,18,HIGb];        % + button position
  %posMNUS = [X1+24,Y7,18,HIGb];       % - button position
  %posSPD  = [X1,Y8,X4+WIDe-X1,HIGt];  % Speed slider position
  %posSPDL = [X1,Y9,WIDl+HS,HIGt];     % Speed slider label position
  %posSPDE = [X4,Y9,WIDe,HIGt];        % Speed slider edit box position
  %posYLML = [X1,Y10,WIDl,HIGt];       % Yaxis limit label position
  %posYLM  = [X4,Y10,WIDe,HIGt];       % Yaxis limit edit box postion
  %posXLML = [X1,Y11,WIDl,HIGt];       % Xaxis limit label position
  %posXLM  = [X4,Y11+2,WIDe,HIGb];     % Xaxis limit Popup position
 
  %posF9L = [X1,Y2,WIDf,HIGt];  %posF9 = [X2,Y2,WIDe,HIGt];  % Ampl (f9) position
  %posF7L = [X1,Y3,WIDf,HIGt];  %posF7 = [X2,Y3,WIDe,HIGt];  % Ampl (f7) position
  %posF5L = [X1,Y4,WIDf,HIGt];  %posF5 = [X2,Y4,WIDe,HIGt];  % Ampl (f5) position
  %posF3L = [X1,Y5,WIDf,HIGt];  %posF3 = [X2,Y5,WIDe,HIGt];  % Ampl (f3) position
  %posF1L = [X1,Y6,WIDf,HIGt];  %posF1 = [X2,Y6,WIDe,HIGt];  % Ampl (f1) position

%end_define

if ~nargin Action='init';    % If no arguments, initialize
else hh = get(gcf,'User');         % handle array
     nsum = get(hh(8),'User');  % # of frequencies/amplitudes currently being used
     amps = get(hh(21),'User');  % the amplitudes are stored here
end;
switch Action
case 'init',
  nsum = 4;            % start using 4 frequencies
  amps = 1./[1:2:9];   % initial amplitudes
  xx = (0:400)*pi/100; % initialize x axis values

% ************* INITIALIZE FIGURES, AXIS, PLOTS, MENUS ***********************

  figure('Color',[.25 .25 .25],'NumberTitle','off','Menu','none','DoubleBuf','on','Resize','off','Position',[160,10,580,340],'Name','E:\mcode\plt\zip_plt\MPP\sum5s.m:  Square wave from sines ','CloseRequestFcn','sum5s quit');
  hh = zeros(1,31);
  hh(1)   = uimenu('Label','&File');
  hh(2)  = uimenu(hh(1),'Label','Open','Callback','sum5s open');  % dummy menu
  hh(3)  = uimenu(hh(1),'Label','Save','Callback','sum5s save');  % dummy menu
  hh(4) = uimenu('Label','&Toggle1','Callback','sum5s toggl1');
  hh(5)   = uimenu('Label','&Help','Callback','help sum5s');
  
  hh(6)  = axes('Color','black','Xcolor','white','Ycolor','white','Units','Pixels','DrawMode','fast','Box','on','NextPlot','add','Position',[177,55,390,270],'XLim',[0 max(xx)],'YLim',[-1.1 1.1],'User',xx);
  hh(7)  = line('Color','green','EraseMode','Normal','Xdata',0,'Ydata',0);
  
% ************************ INITIALIZE CONTROLS *******************************

  uicontrol('Style','Frame','BackgroundColor',[0 .5 .5],'Position',[470,0,95,30]);  % this frames the following 3 buttons
  hh(10 ) = uicontrol('Style','Pushbutton','Position',[475,5,40,17], 'String','Run', 'Callback','sum5s run','enable','off','User',1);
  hh(11) = uicontrol('Style','Pushbutton','Position',[520,5,40,17],'String','Stop','Callback','sum5s stop'); % start running
  
  hh(12)   = uicontrol('Style','Frame','BackgroundColor',[0 .5 .5],'Position',[7,202,143,126]);  % frames X&Y axis limit entry & speed slider
  hh(13)  = uicontrol('Style','Text','BackgroundColor',[.64 .78 .94],'HorizontalAlignment','Center','Position',[8,311,141,16],'String','Plotting controls');
  hh(14)  = uicontrol('Style','Text','BackgroundColor',[.5 .5 .5],'HorizontalAlignment','Left','Position',[12,281,80,16],'String',' X axis limit');
  hh(15)   = uicontrol('Style','Popup','BackgroundColor',[.75 .86 .75],'Position',[97,283,48,17],'Callback','sum5s xlm','String','pi|2 pi|4 pi|8 pi|16 pi',... 
                           'Value',3,'UserData',pi*[1 2 4 8 16]);
  hh(16)  = uicontrol('Style','Text','BackgroundColor',[.5 .5 .5],'HorizontalAlignment','Left','Position',[12,256,80,16],'String',' Y axis limit');
  hh(17)   = uicontrol('Style','Edit','BackgroundColor',[.75 .75 .75],'Position',[97,256,48,16],'String','1.1','Callback','sum5s ylm'); 
  hh(18)  = uicontrol('Style','Slider','Position',[12,215,133,16],'Min',0,'Max',100,'Value',6,'Callback','sum5s spd');
  hh(19) = uicontrol('Style','Text','BackgroundColor',[.5 .5 .5],'HorizontalAlignment','Left','Position',[12,231,85,16],'String',' Speed (0-100):');
  hh(20) = uicontrol('Style','Edit','BackgroundColor',[.75 .75 .75],'Position',[97,231,48,16],'String',num2str(6),'Callback','sum5s spde');

  uicontrol('Style','Frame','BackgroundColor',[0 .5 .5],'Position',[7,7,116,186]);  % this frames all the remaining controls
  uicontrol('Style','Text','BackgroundColor',[.64 .78 .94],'HorizontalAlignment','Center','Position',[8,176,114,16],'String','Data controls');
  hh(8)   = uicontrol('Style','Pushbutton','Position',[14,145,18,17],'String','+','Callback','sum5s plus','User',nsum);
  hh(9)  = uicontrol('Style','Pushbutton','Position',[36,145,18,17],'String','-','Callback','sum5s minus');

             uicontrol('Style','Text','BackgroundColor',[.5 .5 .5],'HorizontalAlignment','Left','Position',[12,120,50,16],'String','AmpF1');   % Amplitude edit box labels
  hh(27) = uicontrol('Style','Text','BackgroundColor',[.5 .5 .5],'HorizontalAlignment','Left','Position',[12,95,50,16],'String','AmpF3');
  hh(28) = uicontrol('Style','Text','BackgroundColor',[.5 .5 .5],'HorizontalAlignment','Left','Position',[12,70,50,16],'String','AmpF5');
  hh(29) = uicontrol('Style','Text','BackgroundColor',[.5 .5 .5],'HorizontalAlignment','Left','Position',[12,45,50,16],'String','AmpF7');
  hh(30) = uicontrol('Style','Text','BackgroundColor',[.5 .5 .5],'HorizontalAlignment','Left','Position',[12,20,50,16],'String','AmpF9','visible','off');

  hh(21) = uicontrol('Style','Edit','BackgroundColor',[.75 .75 .75],'Position',[67,120,48,16],'String',num2str(amps(1)),'Callback','sum5s amp','User',amps); % edit boxes
  hh(22) = uicontrol('Style','Edit','BackgroundColor',[.75 .75 .75],'Position',[67,95,48,16],'String',num2str(amps(2)),'Callback','sum5s amp'); 
  hh(23) = uicontrol('Style','Edit','BackgroundColor',[.75 .75 .75],'Position',[67,70,48,16],'String',num2str(amps(3)),'Callback','sum5s amp'); 
  hh(24) = uicontrol('Style','Edit','BackgroundColor',[.75 .75 .75],'Position',[67,45,48,16],'String',num2str(amps(4)),'Callback','sum5s amp');
  hh(25) = uicontrol('Style','Edit','BackgroundColor',[.75 .75 .75],'Position',[67,20,48,16],'String',num2str(amps(5)),'Callback','sum5s amp','visible','off');
  set(gcf,'User',hh);
  

  sum5s('calc');  % calculate data to be ploted
  sum5s('run');   % start plot

%*************** END OF INIT section *******************************

case 'plus',
  k = nsum;  nsum = k+1;  set(hh(8),'User',nsum);
  if k==1 set(hh(9),'visible','on'); elseif k==5-1 set(hh(8),'visible','off'); end;
  set(hh(k + [26 21]),'visible','on');
  sum5s('calc');

case 'minus',  % - button: Use one fewer frequencies
  k = nsum-1;  nsum = k;  set(hh(8),'User',nsum);
  if k==1 set(hh(9),'visible','off'); elseif k==5-1 set(hh(8),'visible','on'); end;
  set(hh(k + [26 21]),'visible','off');
  sum5s('calc');

case 'run',     % Run button: Start plotting
  am = 0; r = hh(10);  set(r,'enable','off','User',1); set(hh(11),'enable','on');
  while get(r,'User')==1  % this infinite loop is interruptable
    xx = get(hh(6),'User');
    yy = get(hh(7),'User');
    set(hh(7),'Xdata',xx,'Ydata',cos(am)*yy);  drawnow;
    am = am + get(hh(18),'Value') / 3000;  % change the data amplitude
  end;
  if get(r,'User')==-1 set(r,'User',0); sum5s('quit'); end;

case 'quit',    % Close figure
  if get(hh(10),'User') set(hh(10),'User',-1);       % first stop the run loop
  else set(gcf,'CloseRequestFcn','closereq'); close(gcf); % then close the figure
  end;

case 'stop',    % Stop button: Stop plotting
  set(hh(11),'enable','off');  set(hh(10),'enable','on','User',0);

case 'amp',     % Amplitude edit boxes: Save results in amps
  for k = 0 : nsum-1
    a = eval(get(hh(21+k),'String'),'''err''');
    if isstr(a) | a<0  fprintf(1,char(7)); set(hh(21+k),'String',num2str(amps(k+1)));
    else amps(k+1) = a;
    end;
  end;
  set(hh(21),'User',amps);
  sum5s('calc');

case 'toggl1',  % Toggle1 menu: Make frame 1 appear/disappear
  if strcmp(get(hh(12),'Visible'),'on') a = 'off'; else a = 'on'; end;
  set(hh(12:20),'Visible',a);

case 'calc',    % recompute data to be plotted
  xx   = get(hh(6),'User'); % get the x vector
  yy = amps(1) * sin(xx);
  for k = 2:nsum  yy = yy + amps(k) * sin((2*k-1)*xx); end;
  set(hh(7),'User',yy);     % save the result


case 'ylm',     % Yaxis limit edit box 
  k = eval(get(hh(17),'String'),'''err''');
  if isstr(k) | k <= 0  fprintf(1,char(7)); k=1.1; set(hh(17),'String','1.1'); end;
  set(hh(6),'YLim',[-k k]);

case 'xlm',     % Xaxis limit popup
  xmx = get(hh(15),'User');
  xmx = xmx(get(hh(15),'Value'));
  set(hh(6),'XLim',[0 xmx],'User',[0:.01*pi:xmx]);  % save new xlimit and x vector
  sum5s('calc');

case 'spd',     % Speed slider: adjust amplitude rate of change
  set(hh(20),'String',num2str(get(hh(18),'Value'))); % sync edit box

case 'spde',    % Speed slider edit box
  k = eval(get(hh(20),'String'),'''err''');
  if isstr(k) | k < 0 | k > 100
     fprintf(1,char(7)); set(hh(20),'String',num2str(get(hh(18),'Value')));
  else set(hh(18),'Value',k);  % sync slider
  end;

case 'open',   disp('File Open was selected');  % dummy menu
case 'save',   disp('File Save was selected');  % dummy menu
otherwise, fprintf(1,'sum5s Action %s not recognized\n',Action)

end; % end switch statement
% end sum5s

