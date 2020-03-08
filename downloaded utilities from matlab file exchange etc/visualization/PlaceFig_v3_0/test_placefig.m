close all
clear functions %remove previous run virtual screen size if any

% "virtual screen size" : change screen portion used
placefig([],[],[],[], [], [], 1, 1600, 1200)

x       = 0:.001:1;
parVals = 1:8; 
colors      = {'b','m','r',[1 1 1]*0.5};
for ip=1:length(parVals)
    
    figure(100+ip); 
%     placefig(100+ip,2,4,ip);
    placefig(100+ip,2,4);
    hold on; set(gca,'FontSize',16); set(gca,'FontName','Times'); set(gcf,'Color',[1,1,1]);
    xlabel('x');ylabel('y');
    col           =  colors{1+mod(ip-1,length(colors))};
    g             =  parVals(ip);
    y             =  sin(2*pi*x*g);   % a function that changes with parameter g
    title(sprintf('f=%s',num2str(g)));
    line(x,y,'color',col,'linewidth',2);
    axis tight
    grid on
end

