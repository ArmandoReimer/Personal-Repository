function hisMat = timeSandbox(hisFile)

t = timer('TimerFcn', @loadHisCallback, 'UserData', hisFile);
start(t)
hisMat = t.UserData;

end

function loadHisCallback(obj, event)

hisFile = obj.UserData;
hisMat= loadHisMat(hisFile);
obj.UserData = hisMat;

end