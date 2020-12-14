function videogame()

main = figure();
ax = axes(main);
ylim(ax, [0, 50]);
x = 0;
y = 0;

cc = 1;
%This flag allows the code to directly pass a command without waiting for
%the user to press a key or click on the figure
SkipWaitForButtonPress = [];

while (cc ~= 'x')
    
    plot(ax, x, y, 'o');
    
    if isempty(SkipWaitForButtonPress)
        % Wait for user input to select command to execute
        ct = waitforbuttonpress; % ct=0 for click and ct=1 for keypress
        cc = get(main, 'CurrentCharacter');
        cm2 = get(ax, 'CurrentPoint');
        
        if strcmpi(cc, '') || ct == 0
            cc = 'donothing';
        end 
    else
        cc = SkipWaitForButtonPress;
        SkipWaitForButtonPress = [];
    end
    
     if strcmpi(cc, 'donothing')
        %do nothing
        
    elseif cc == 'w'%Move forward one frame
         y = y + 10;
     end
    
    
    
end



ax.Visible = 'off';



end