close all;
format long;

%here i read in the data--------------------------------------------------
n_stacks = 2;
connection = tcpip('128.32.173.234');
fopen(connection);

for j = 1:n_stacks

    start_command = '/cli:Leica-SP8PR-WS /app:matrix /cmd:startscan';
    fwrite(connection, start_command);

    expdir = dir('D:\MatrixScreenerImages\3.3.0_9757');
    stackpath = [expdir(end), '\b--S00\c--U00--V00\d--X00--Y00\AF'];
    xml = [stackpath, '\metadata\image--L0000--S00--U00--V00--J19--E00--O00--X01--Y01--T0000.ome.xml'];
    xmltext = fileread(xml);
    expressiongalvo = '(?:StagePosition PositionX=".*" PositionY=".*" PositionZ=")(-?\d\.\d*E-\d)';
    mid_zgalvo = regexp(xmltext, expressiongalvo, 'tokens');
    mid_zgalvo = str2double(mid_zgalvo{1});
    expressionobj = '(?<=AdditionalZPosition - ZPosition" Value=")(0.00\d*)';
    zobj = str2double(regexp(xmltext, expressionobj, 'match')); %this value is the same for all the files, so may as well retrieve it from the final slice
  
    zsize = 21;

    %here i do the algorithm-------------------------------------------------
    
    n_nuclei_list = [];
    
    for i = 1:zsize
        
            if i >= 10
            tif = [stackpath, 'image--L0000--S00--U00--V00--J19--E00--O00--X01--Y01--T0000--Z',num2str(i),'--C01.ome.tif'];
        else 
            tif = [stackpath, 'image--L0000--S00--U00--V00--J19--E00--O00--X01--Y01--T0000--Z0',num2str(i),'--C01.ome.tif'];
        end
        im = imread(tif);
        imshow(im,[]);
        filterSize = 20; %size of square to be convolved with microscopy images
        dog = conv2(single(im2), single(fspecial('gaussian',filterSize, 1.5) - fspecial('gaussian',filterSize, 5)),'same');
        dog = double(dog > .1); %this isn't going to work under all imaging conditions. need to find another way to convert to bw
        dog = imgaussfilt(dog,3);
        imshow(dog,[]);
        [im_label, n_nuclei] = bwlabel(im2bw(dog));
        n_nuclei_list(i) = n_nuclei;
            
    end
    
    [max, max_index] = max(n_nuclei_list);
    z_step = .5; %in the future, i'll parse this from the xml but currently lazy
    mid_plane = (zsize+1) / 2;
    max_zgalvo = mid_zgalvo - (mid_plane - max_index)*0.5;
    delta_z = mid_zgalvo - max_zgalvo;
    new_zobj = zobj + delta_z;
    
    %here go the commands to leica-------------------------------------------------
    
    
    move_objective_command = ['/cli:Leica /app:matrix /sys:0 /cmd:setposition /typ:absolute',...
                '/dev:zdrive /unit:microns /zpos:', new_zobj];
    fwrite(connection, move_objective_command);
    
end

fclose(connection);