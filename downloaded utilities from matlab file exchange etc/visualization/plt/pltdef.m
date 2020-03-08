%pltdef.m

maxLN      = 99;   % Max # of traces
CmarkSZ    = 0.8;  % Cursor marker size relative to fontsize

% definitions for plt('slider') -----------------
  HSLDc = 17; % slider height
  SSP1c = 17; % slider spacing #1
  SSP2c = 33; % slider spacing #2
  HTXTc = 16; % text height 
  % slider handle indicies
  label=2;    % 1 is spare (could start at 1)
  slide; mintxt; maxtxt; valro; mode1; quant;
  last_h = quant;
  lastobj = valro;
  % slider movement modes
  LINc     = 1; % linear
  LININTc  = 2; % linear with integers only
  POWOF2c  = 3; % powers of 2
  LININTQc = 4; % quantize to defined step size
  LOGc     = 5; % log steps
  UNITc    = 6; % step size always = 1

% definitions for plt('pop') -----------------
             % indices into text object's UserData property
  Uaxis=1;   % popup axes handle
  Uchoice;   % popup choices
  Uindex;    % pointer to choices array
  Ucallbk;   % popup callback
  Uoff;      % offset for opened popup [x y]
  Ufr;       % popup foreground color
  Uena;      % popup enable
  Uhide;     % objects to hide when popup open
  Uterp;     % interpreter for popup text objects
  Ulbl;      % handle of popup label (0 for no label)
  Uswap;     % true to swap meanings of left & right clicks

% definitions for plt('edit') -----------------
             % indices into text object's UserData property
  Wvalue=1;  % edit objects current value
  Wmin;      % edit objects minimum allowed value
  Wmax;      % edit objects maximum allowd value
  Wcallbk;   % edit object's callback
  Wena;      % enable
  Wincr;     % left click increment amount
  Wlen;      % length of value vector (0 for strings)
  Wfmt;      % format conversion (default = '%7w')
  Wlbl;      % handle of edit label (0 for no label)
  Wolds;     % save old string before user character input
  Woldi;     % save old interpreter before user character input

% definitions for plt('hcpy') -----------------
  FigHC = 1;
  OpenPB; ModePU; bwRB; ColorRB; ClipBdRB;
  FileRB; DevRB; PrintPB; FileLBL; PathFile;
  PicFig    = 12; % owner figure handle (index)
  dlgBKc = [0,.4,.4];     % Dialog background
  lblBKc = [.8,.8,.9];    % label text background
  lblFRc = 'black';       % label text foreground

% definitions for plt('cursor') ---------------
    % Handle & ancilary index definitions
    % ***** leave ixlabel through imkbut in the order below *********
    ixlabel = 2; % userdata stores all object handles
    iylabel;     % userdata stores readout edit box formats
    ixro;        % x axis edit box. userdata has misc parameters (see J indicies below)
    ixexp;       % x axis expansion edit, userdata has axis change callback
    iyro;        % userdata stores expansion history in Nx(4+1) array.
                 % 1st 4 elements have initial axis state, 5th column is a marker
    iyexp;       % y axis expansion edit, userdata has cursor move callback
    ipkbut;      % peak finder button
    ivalbut;     % valley finder button
    imlsbut;     % marker line style button
    imkbut;      % mark button for delta mode
                 % leave above objects in same order to match position input order
    iexpbox;     % expansion box line object, userdata stores point for axis click
    imkline;     % mark line object, userdata has who was active when the mark was made
    iaxOwner;    % owner axis handle
    iaxAux;      % underlying axis handle (if plots are overlayed, owner on top)
    icurbase = iaxAux; % base of cursors  @ last 'normal' object , cursors build from here
%   icurbase+1;  % 1st cursor
%   icurbase+2;  % 2nd cursor (userdata stores associated line object handle & color_track flag)
%   ...
%   icurbase+nc; % last cursor

    % indicies for misc() data stored in x axis edit box (ixro) user data
    Jix = 1;    % index for main axes Xdata cursor
    Jx;         % last x cursor value
    Jy;         % last y cursor value
    Jact;       % cursor that is currently active (for multiple plots on 1 axes)
    Jmonoflag;  % 1=if data is monotonic in x, 0 if not, -1 if not set in init
    Jyaux;      % last overlay y axis cursor value
    Jxexp;      % in x axis expand mode from button
    Jyexp;      % in y axis expand mode from button
    Jlast = Jyexp;

    EXPMAXc  = 4;  % max number of expansions +1 saved, e.g. 4=(3 expansions) + (the original axis limits)
    EXPMAXc1 = EXPMAXc+1;
    EXPMAXcm = EXPMAXc-1;
    EXPFLAGc = 5;  % where the flag is kept
    EXPFLAGcm = EXPFLAGc-1;

    NONEc=0; BOTHc; XONLYc; YONLYc;  % autoscale modes
% plot select State matrix column definitions
    SVtxt = 1;  % text handles
    SVsz1;      % number of rows in variable
    SVsz2;      % number of columns in variable
    SVlen;      % length of variable, i.e. max(sz1,sz2)
    SVnvec;     % number of vectors in variable, i.e. min(sz1,sz2);
    SVsxy;      %  0 if not selected
                % <1 if selected as a x vector
                % >0 if selected as a y vector
    SVright;    % 1 if assigned to the right hand axis
