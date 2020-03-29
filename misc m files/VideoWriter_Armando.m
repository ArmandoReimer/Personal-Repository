%% Make a Movie 

%Make a Movie
writerObj = VideoWriter('E:\Data\Armando\Name_of_the_file.avi'); % set the saving folder,name the file
writerObj.FrameRate = 5; % How many frames per second.
open(writerObj); 

hold on
for i=1:10
   x(i)=i;
   y(i)=i^2;
   plot(x(i),y(i),'Marker','o')
   frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
   writeVideo(writerObj, frame);
end
hold off


close(writerObj);