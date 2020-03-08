%EMAR method 
function [IClust,EL,NUMEllipses] =  runGMMFitting(I,AICBIC_SELECTION)
Iorig = I;
lines = size(I,1);
cols = size(I,2);
I = zeros(3*lines,3*cols);
I(lines+1:2*lines,cols+1:2*cols) = Iorig;
NUMEllipses = 0;
[nCompl] = getObjectComplexity(I);
FULLPLOT = 0;
[Points(:,1) Points(:,2)] = find(I > 0);
X = zeros(round(sum(sum(I))),2);
W = ones(1,size(Points,1));
k = 1;
for i=1:size(Points,1),
    for j=1:W(i),
        X(k,1:2) = Points(i,1:2);
        k = k+1;
    end
end

%figure;
%scatter(X(:,1),X(:,2),10,'r+')
hold on
area = size(Points,1);
options = statset('Display','final');
minAICBIC = 10000000;
IClust = I;
if NUMEllipses <= 0,
    for i=1:25,%25
        NUMEllipses_SEL = i;
        try
           obj = gmdistribution.fit(round(X),i,'Options',options);
        catch
            NUMEllipses_SEL = i-1;
            obj = obj_prev;
            disp('Catch Error');
        end
        obj_prev = obj;
        [EL,DTemp,IClust,TotalPerf] = getELFromGMM(obj,IClust,area);
        %h = ezcontour(@(x,y)pdf(obj,[x y]),[0 size(I,1)],[0 size(I,2)]);
        %TotalPerf = sum([EL.InArea]) / area;
        
        [AIC1,BIC1,RES_AICBIC,bestAICBIC,SI1(1,1:3)] = getAIC_BIC(nCompl,TotalPerf,NUMEllipses_SEL,AICBIC_SELECTION,IClust,EL);
        
        if RES_AICBIC < minAICBIC,
            IClustBest = IClust;
            NUMEllipses = NUMEllipses_SEL;
            minAICBIC = RES_AICBIC;
            AIC(i) = AIC1;
            BIC(i) = BIC1;
            SI(i,1:3) = SI1(1,1:3);
            BestDTemp = DTemp;
            BestTotalPerf = TotalPerf;
            BestEL = EL;
            %break;
        else
            AIC(i) = AIC1;
            BIC(i) = BIC1;
            SI(i,1:3) = SI1(1,1:3);
            BestDTemp = DTemp;
        end
        
        if bestAICBIC < minAICBIC,%?????10
            if FULLPLOT == 1,
                [~] = drawDistEllClusteting(BestDTemp,EL,0,0);
                title(sprintf('TotalPerf = %2.4f ',TotalPerf));
            end
        else
            break;
        end
        
    end
else
    
end
TotalPerf = BestTotalPerf;
IClust = IClustBest;
EL = BestEL;
[hfig2] = drawEllClusteting(IClust,EL,0,0);
for i=1:NUMEllipses,
    hold on;
    text(EL(i).C(1),EL(i).C(2),sprintf('%d',i));
end
title(sprintf('%4.2f',100*TotalPerf));

hfig3 = figure;
plot(AIC,'-.o');
hold on;
plot(BIC,'--rs');
legend('AIC','BIC');


%convert an obj to EL data structure

function [EL,Dtemp,IClustNew,TotalPerf] = getELFromGMM(obj,IClust,area)

lines = size(IClust,1);
cols = size(IClust,2);
NUMEllipses  = length(obj.PComponents);
Dtemp = zeros(lines,cols);
IClustNew = IClust;
BW = IClust > 0;
totalArea = 0;


for val=1:length(obj.PComponents),
    V = obj.Sigma(:,:,val);
    [eigenvec, eigenval ]=eig(V);
    [largest_eigenvec_ind_c, r] = find(eigenval == max(max(eigenval)));
    largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);
    
    % Get the largest eigenvalue
    largest_eigenval = max(max(eigenval));
    % Get the smallest eigenvector and eigenvalue
    if(largest_eigenvec_ind_c == 1)
        smallest_eigenval = max(eigenval(:,2));
        smallest_eigenvec = eigenvec(:,2);
    else
        smallest_eigenval = max(eigenval(:,1));
        smallest_eigenvec = eigenvec(1,:);
    end
    
    % Calculate the angle between the x-axis and the largest eigenvector
    %angle = atan2(largest_eigenvec(2), largest_eigenvec(1));
    angle = atan2(largest_eigenvec(1), -largest_eigenvec(2));

    % This angle is between -pi and pi.
    % Let's shift it such that the angle is between 0 and 2pi
    
    angle = pi+angle;
    

    %ð ÷^2 l1 l2 = area 
    %÷^2 = area / (ð l1 l2)
    chisquare_val = 1;%area / (max(0.0000000001,pi*sqrt(largest_eigenval*smallest_eigenval)));
    a=sqrt(chisquare_val)*sqrt(largest_eigenval);
    b=sqrt(chisquare_val)*sqrt(smallest_eigenval);


    EL(val).a = a; 
    EL(val).b = b;
    EL(val).C(1) = obj.mu(val,2);
    EL(val).C(2) = obj.mu(val,1);
    EL(val).phi = 180*angle/pi;
    totalArea = totalArea+pi*a*b;
end

totalArea2 = 0;
for val=1:length(obj.PComponents),
     EL(val).a = EL(val).a*sqrt(area/totalArea); 
     EL(val).b = EL(val).b*sqrt(area/totalArea); 
     totalArea2 = totalArea2+pi*EL(val).a*EL(val).b;
end
%logos = totalArea2 / area
p = [];
for val=1:length(obj.PComponents),
    V = obj.Sigma(:,:,val);
    [eigenvec, eigenval ]=eig(V);
    [largest_eigenvec_ind_c, r] = find(eigenval == max(max(eigenval)));
    largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);
    
    % Get the largest eigenvalue
    largest_eigenval = max(max(eigenval));
    % Get the smallest eigenvector and eigenvalue
    if(largest_eigenvec_ind_c == 1)
        smallest_eigenval = max(eigenval(:,2));
        smallest_eigenvec = eigenvec(:,2);
    else
        smallest_eigenval = max(eigenval(:,1));
        smallest_eigenvec = eigenvec(1,:);
    end
    
    % Calculate the angle between the x-axis and the largest eigenvector
    %angle = atan2(largest_eigenvec(2), largest_eigenvec(1));
    angle = atan2(largest_eigenvec(1), -largest_eigenvec(2));

    % This angle is between -pi and pi.
    % Let's shift it such that the angle is between 0 and 2pi
    angle = pi+angle;
    angle = 180*angle/pi;
    
    a=EL(val).a;
    b=EL(val).b;

    [x y] = meshgrid(1:max(lines,cols),1:max(lines,cols));
    
    el=((x-obj.mu(val,2))/a).^2+((y-obj.mu(val,1))/b).^2<=1;
    
    el = rotateAround(el,obj.mu(val,1),obj.mu(val,2),angle,'nearest');
    el = el(1:lines,1:cols);
    p1 = [];
    p2 = [];
    [p1(:,1) p1(:,2)] = find(el == 1 & BW == 1);
    [p2(:,1) ~] = find(el == 1 | BW == 1);
    p = union(p,p1(:,1)+lines*cols*p1(:,2));
    tomh_area = size(p1,1) / (pi*a*b);
    tomh_enwsh = size(p1,1) / size(p2,1);
    
    EL(val).InArea = size(p1,1);
    EL(val).outPixels = size(p2,1) - size(p1,1);
    EL(val).tomh_area = tomh_area;
    EL(val).tomh_enwsh = tomh_enwsh;
    EL(val).Label = val;
end


for i=1:lines,
    for j=1:cols,
        if IClust(i,j) > 0,
            d = zeros(1,NUMEllipses);
            for k=1:NUMEllipses,
                OAdist = norm([j i] - EL(k).C);%?????
                OXdist = getOX([j i],EL(k));
                d(k) = OAdist/max(OXdist,0.00001);
            end
            Dtemp(i,j) = min(d);
            
            [~,pos] = min(d);
            IClustNew(i,j) = pos;
        end
    end
end

TotalPerf = size(p,1)/area;
    




