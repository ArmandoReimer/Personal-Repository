
dt = 5;
tf = 1E4;
to = 0;
pols = [];
nPols = 0;
gene_length = 3000;
ms2_length = 1500;
pTerminate = 0;
pInitiate = .1;
fluo = [];
  %experimental parameters
TIME_PER_FRAME = 10; %s
NOISE_SCALE_EXP = 0; %au
MEAN_POL_LOADING_RATE = 8; %pol/min
MEAN_POL_OFFLOADING_RATE = 8; %pol/min
MEAN_BACKGROUND = 0; %au
DETECTION_LIMIT = 0; %au
MCP_INTENSITY = .2; %au / frame / mcp-gfp
FLUO_CALIBRATION = 25; %au / polymerase
%biological parameters
REPORTER_LENGTH = 3; %kb. this is ~lacZ
N_LOOPS = 24; %v5
LOOP_SIZE = .0583; %kb. ms2v1, v5 or v7
GENE_LENGTH = REPORTER_LENGTH + LOOP_SIZE.*N_LOOPS;
ELON_RATE = 2.5; %kb/min
LOOP_RATE = 47; %loops / min. (.783 loops/s)
T_INIT = 3; %min
T_FIN = 8; %min
INTERPHASE = 10; %min
POL_FOOTPRINT = .04; %kbp
N_POLS = round(GENE_LENGTH ./ POL_FOOTPRINT);
NOISE_SCALE_BIO = 0; %au
FRACTION_ACTIVE = .4;


rng(1, 'twister')
n = 0;
for t = to:dt:tf
    n = n + 1;
    %1. preinitiation
    %2. %initiation
    r = rand;
    if r < pInitiate
        newPol = struct('position', 0, 'deleteMe', false, 'nLoops', 0);
        pols = [pols; newPol];
        pols(end).position = 0;
    end
    %3. elongation
    for p = 1:length(pols)
        pols(p).position = pols(p).position + 1;
        if pols(p).position < ms2_length
            if ~mod(pols(p).position, 50)
                pols(p).nLoops = pols(p).nLoops + 1;
            end
        end
    end
    %4 termination
    for p = 1:length(pols)
        r = rand;
        if r < pTerminate
            pols(p).deleteMe = true;
        end
    end
    
    if ~isempty(pols)
        pols([pols.deleteMe]) = [];
        fluo(n) = sum([pols.nLoops]);
    else
        fluo(n) = 0;
    end
end

tiledlayout('flow')
nexttile;
plot(to:dt:tf, fluo);
nexttile;
histogram(fluo);