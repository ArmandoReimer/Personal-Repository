function [ Monitor1, MonitorPositions ] = getScreenSizeFunc()
%GETSCREENSIZEFUNC()
%  Returns the actual size in pixel of the main monitor
%  based on Ulrik' answer in : https://nl.mathworks.com/matlabcentral/answers/312738-how-to-get-real-screen-size 
if 0
   
    Mon1=[];
    warning off
    % ScreenPixelsPerInch = java.awt.Toolkit.getDefaultToolkit().getScreenResolution();
    ScreenDevices = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment().getScreenDevices();
    MainScreen = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment().getDefaultScreenDevice().getScreen()+1;
    MainBounds = ScreenDevices(MainScreen).getDefaultConfiguration().getBounds();
    MonitorPositions = zeros(numel(ScreenDevices),4);
    for n = 1:numel(ScreenDevices)
        Bounds = ScreenDevices(n).getDefaultConfiguration().getBounds();
        MonitorPositions(n,:) = [Bounds.getLocation().getX() + 1,-Bounds.getLocation().getY() + 1 - Bounds.getHeight() + MainBounds.getHeight(),Bounds.getWidth(),Bounds.getHeight()];

        if MonitorPositions(n,1) ==1 && MonitorPositions(n,2) ==1
            Mon1 = MonitorPositions(n,:);
        end
    end
    % MonitorPositions
    warning on
else

    % since ML 2016 the features above are not working anymore, 
    % due to a possible windows scaling e.g. @ 125% it reports a silly 1536 x 864 iso 1920 x 1080 
    % this is done win Win10 virtualization to show larger characters on screen
    % ref: https://windows.gadgethacks.com/how-to/change-font-size-windows-10-0166687/
    %      DisplaySettings/FontSize/slider "change the size of text, apps, and other items"
    %luckily we can still get the true size in true pixels, not scaled pixels    

    % https://nl.mathworks.com/matlabcentral/answers/312738-how-to-get-real-screen-size    
    ge = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment;
    gd = ge.getDefaultScreenDevice;
    TRUE_screensize = [gd.getDisplayMode.getWidth gd.getDisplayMode.getHeight];
    
    Monitor1=[1,1,TRUE_screensize];
    MonitorPositions = [];
end

end

