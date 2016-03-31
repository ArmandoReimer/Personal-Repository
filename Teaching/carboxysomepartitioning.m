%Simulate carboxysome partitioning

%Model parameters

Nmother = 100;      %number of carboxysomes in mother
p = .5;

%Simulation parameters

Nrepetitions = 1000;

for i = 1:Ncells
    %Second for loop to flip a coin for each carboxysome within this
    %simulated cell
    for j=1:Nmother
        RandNumber = rand;
        if RandNumber < p;
            Flips(j) = 1;
        else
            Flips(j) = 0;
        end
    end
    
    %Sum over flips to get the number of carboxysomes that went to daughter
    %cell 1
    
    N1(i) = sum(Flips);
    figure(1)
    hist(N1, 0:Nmother)
    drawnow %forces matlab to plot
    pause(.1)
end
