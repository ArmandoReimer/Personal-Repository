function randomwalker

n = 10000;
pos = struct;
ro = [0, 0, 0];
pos(1).x = ro(1);
pos(1).y = ro(2);
pos(1).z = ro(3);
pos(1).t = 0;
nuclear_radius = 500;  %radius in 10 nm increments. forms reflective boundary for random walkers.
%10 nm because that's roughly the size of bcd-gfp
rng('shuffle');
for i = 2:n
    u = rand*100;
    if u < 100/6
       pos(i).x = pos(i-1).x + 1;
       pos(i).y = pos(i-1).y;
       pos(i).z = pos(i-1).z;
    elseif 100/6 < u && u < 200/6 
        pos(i).x = pos(i-1).x - 1;
       pos(i).y = pos(i-1).y;
       pos(i).z = pos(i-1).z;
    elseif 200/6 < u && u < 300/6
        pos(i).x = pos(i-1).x;
       pos(i).y = pos(i-1).y - 1;
       pos(i).z = pos(i-1).z;
    elseif 300/6 < u && u < 400/6
        pos(i).x = pos(i-1).x;
       pos(i).y = pos(i-1).y + 1;
       pos(i).z = pos(i-1).z;
    elseif 400/6 < u && u < 500/6
       pos(i).x = pos(i-1).x;
       pos(i).y = pos(i-1).y;
       pos(i).z = pos(i-1).z + 1;
    else
       pos(i).x = pos(i-1).x;
       pos(i).y = pos(i-1).y;
       pos(i).z = pos(i-1).z -1;
    end
    if sqrt( (pos(i).x)^2 + (pos(i).y)^2 + (pos(i).z)^2 ) >= nuclear_radius
       pos(i).x = pos(i-1).x;
       pos(i).y = pos(i-1).y;
       pos(i).z = pos(i-1).z;
    end
    pos(i).t = pos(i-1).t + 1;
end


x = [pos.x];
y = [pos.y];
z = [pos.z];
c = [pos.t];
figure
cmap = colormap;
% change c into an index into the colormap
% min(c) -> 1, max(c) -> number of colors
c = round(1+(size(cmap,1)-1)*(c - min(c))/(max(c)-min(c)));
% make a blank plot
plot3(x,y,z,'linestyle','none')
% add line segments
for k = 1:(length(x)-1)
    line(x(k:k+1),y(k:k+1),z(k:k+1),'color',cmap(c(k),:));
end
hold on;
colorbar
xlabel('x');
ylabel('y');
zlabel('z');
[sx,sy,sz] = sphere(300);
a=0;
b=0;
c=0;
r=5;
% surf(r*sx+a, r*sy+b, r*sz+c) % where (a,b,c) is center of the sphere
alpha(.2)

end