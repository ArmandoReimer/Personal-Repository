% tasplt.m (aircraft performance chart) -----------------------------------
%
% This script file creates two plots each consisting of 9 traces.
% The following plt tricks and features are demonstrated:
% - Note that these figures plot multiple valued functions (i.e. relations).
% - The first plot (efficiency and range chart) creates a trace for each
%   column of gph and mpg (9 columns for 9 altitudes)
% - Demonstrates adding an additional axis to show alternate units on
%   the right hand and/or top axis. (Note that these axes don't actually
%   contain any traces, unlike the usual plt right hand axis.)
% - Demonstrates annotating a graph with equations using the HelpText parameter. 
% - Demonstrates how the cursors in two plots can be linked. Moving
%   one, moves the other. Also in this example switching the active
%   trace in one plot does the same in the other as well. 
% - Uses the 'Xstring' and 'Ystring' parameters to display alternate units
% - Shows how to close both figures when either plot is closed by
%   using the Link parameter.
% - Shows how to use the 'pos' parameter to position two figures as far
%   apart as possible given the available screen area.
% - The 'HelpText' parameter is used to annotate the true airspeed chart
%   with the equations that are used to generate the plotted data.

% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

Pdrag = 44.072e-7; Idrag = 269.46;        % parasitic/induced drag coefficients
                                          % change these for a different airplane
alt = 0:4:32;                             % altitudes (thousands of feet);
sigma = (1-alt/145.442).^4.25588;         % density ratio
ymin=50; ymax=186; tas = (ymin:.1:ymax)'; % airspeed range
gph = Pdrag * tas.^3 * sigma + Idrag./(tas * sigma); % power required equation
traceID = prin('sea level{ ~, %2d,000 ft}',alt(2:end));

% Now do efficiency and range chart ----------------------------------------------

mpg = repmat(tas,1,length(alt)) ./ gph;   % compute efficency (tas/gph)
xmn = 5;  xmx = 16;  ymn = 8.9; ymx = 14.7;
tg = 'set(findobj(gcf,"tag","ts"),';  % find the alternate axis
ys = '"ylim",get(gca,"ylim")*80,';    % range is 80 times nm/gal (axis limits)
yt = '"ytick",get(gca,"ytick")*80,';  % range is 80 times nm/gal (tick marks)
xs = '"xlim",get(gca,"xlim")*5)';     % percent power is 5 times gph
sz = [880 600];                       % figure size

plt(gph,mpg,...
    'FigName','Cessna 185 Efficiency & Range - standard temp (N3946Q)',...
    'Xstring','sprintf("%3.1f%% power",5*@XVAL)',...
    'Ystring','sprintf("Range: %dnm",round(80*@YVAL))',...
    'LabelX','Fuel flow (gph)','xy',[.11 .09 .82 .838],...
    'LabelY','Nautical miles per gallon','TraceID',traceID,...
    'Pos',[0 0 sz],'Options','S-X-Y','AxisCB',[tg ys yt xs]);

% Display 'Percent Power' as an alternative x-axis units above the graph
% Display 'Range'         as an alternative y-axis units to the right of the graph
ax1 = gca;  hfig = gcf;
ac = get(get(ax1,'ylabel'),'color');
axr = axes('tag','ts','XaxisLoc','top','YaxisLoc','right','pos',get(ax1,'pos'),...
           'ticklen',[.002 0],'tickdir','out','xcolor',ac,'ycolor',ac);
set(get(axr,'xlabel'),'string','Percent Power');
set(get(axr,'ylabel'),'string','Range (nm) - assumes 80 gal useable, no reserve');
axes(ax1);                                    % put primary axis on top
cid1 = get(ax1,'User');                       % get cursor ID for 1st plot
plt('cursor',cid1,'xylim',[xmn xmx ymn ymx]); % set plot 1 xy limits

% Now do true air speed chart -------------------------------------------------
htxt = 'p = parasite drag coef = %7.5f\\times10^{-6}';
htxt = {'gph  =  \sigma p V^3  +   i  /  \sigma V' .58+.25i 'fontsize' 16 2i ...
        'where:' .62+.185i 'fontsize' 9 'fontangle' 'italic' 2i ...
        sprintf(htxt,Pdrag*1e6) .62+.16i 2i ...
        sprintf('i = induced drag coef = %7.3f',Idrag) .62+.108i 2i ...
        '\sigma = air density ratio = \rho / \rho_{SL}' .62+.07i };
plt(gph,tas,'Pos',[sz+15 sz],'Options','S-X-Y',...
    'FigName','Cessna 185 True Airspeed Chart - standard temp (N3946Q)',...
    'AxisCB',[tg xs],'Xstring','sprintf("%3.1f%% power",5*@XVAL)',...
    'LabelX','Fuel flow (gph)','Link',gcf,'xy',[.115 .09 .87 .838],...
    'LabelY','True Airspeed (Knots)','TraceID',traceID,'HelpText',htxt);

% Display 'Percent Power' as an alternative x-axis units above the graph
ax2 = gca;
axr = axes('tag','ts','XaxisLoc','top','pos',get(ax2,'pos'),...
           'xcolor',ac,'ycolor',get(gcf,'color'));
set(get(axr,'xlabel'),'string','Percent Power');
axes(ax2);                                   % put primary axis on top
cid2 = get(ax2,'User');                      % get cursor ID for 2nd plot
plt('cursor',cid2,'xylim',[10 17 115 ymax]); % set plot 2 xy limits

% Cursor movement in 1st plot also moves cursor in 2nd plot and visa versa
s1 = 'plt("cursor",';  s2 = ',"setActive",@LNUM,@IDX);';
plt('cursor',cid1,'moveCB',[s1 int2str(cid2) s2]);
plt('cursor',cid2,'moveCB',[s1 int2str(cid1) s2]);
