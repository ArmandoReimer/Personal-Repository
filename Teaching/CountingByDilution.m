% In this computational exploration we want to simulate the random
% partitioning of fluorescent molecules between the two daughters after
% cell division. By looking at the fluctuations in this partitioning 
% we will be able  to relate the intensity to the number of molecules
% through the calibration factor.

% The idea is to choose a number of molecules in a mother cell and flip a
% coin for each one of those molecules in order to decide whether it will
% go to daughter cell number 1 or daughter cell number 2. We will then
% repeat this procedure "Ncells" times.
Ncells=100;

% We need to decide how many molecules the mother cell will have.
% Let's define a vector that has  values spanning
% between 0 and 2000 molecules per mother cell and we will step
% through these values in increments of 25.
Ntot=0:25:500;

% Now, we create vectors for each daughter cell where we will save the
% result of each coin flip. In order to initialize them we use the function
% "zero" which creates a zero matrix of the dimensions given in its
% argument. In this case the matrices will have Ncells rows and columns
% corresponding to each element of Ntot, the starting number of molecules
% in the mother cell
D1=zeros(Ncells,length(Ntot));  %Daughter 1
D2=zeros(Ncells,length(Ntot));  %Daughter 2

% We want to define various loops that walk us through the repeated series
% of cell divisions and partitioning events. The first loop (index k)
% will go through each element of Ntot, the different starting number
% of molecules in the mother cell. The second for loop (index j) 
% will repeat the process of division Ncell times. Finally, the 
% third loop (index i) will flip the coin for each one of the molecules.
for k=1:length(Ntot)
    for j=1:Ncells
        for i=1:Ntot(k)
            %In order to decide if the molecule goes to daughter 1 or
            %daughter 2 we draw a random number between zero and one.
            %This is done using the function "rand". If the result is
            %larger than 0.5, then assign the molecule to daughter 1.
            %Otherwise assign it to daughter 2.
            Num=rand;

            %It is important to keep track of the various indices. Remember
            %the definitions of "j" and "k".
            if Num>0.5
                D1(j,k)=D1(j,k)+1;
            else
                D2(j,k)=D2(j,k)+1;
            end
        end
    end
end


% We want to simulate an actual experiment where we can measure
% fluorescence, but not directly count the number of molecules in a cell.
% In order to related fluorescence and number of molecules we define the
% calibration factor "alpha".
alpha=50; 

%Using this calibration factor we now generate  vectors that are related to
%intensity. For the total number of molecules in the mother cell we get
Itot=alpha*Ntot;
%and for the daughter cells we get
I1=alpha*D1;
I2=alpha*D2;
% Note that these intensities are themselves variables with indices.


%As mentioned in the book and schematized in Figure 2.11, we can measure
%the fluorescence of the mother cell and the fluctuations in the
%partitioning of fluorescence between the daughter cells. Let's generate
%this plot.
figure(1)
plot(Itot,sqrt((I2-I1).^2),'.k')
xlabel('I_1 + I_2 (au)')
ylabel('|I_1 - I_2|')


% Can we infer the calibration factor from our simulated data? In order to
% do that notice that Equation 2.11 tells us that there is a linear relation
% mean square difference in fluorescence and the total fluorescence and that
% the proportionality constant is given by the calibration factor.

% Let's start by calculating the mean square partitioning error using the
% function "mean". Notice that we square the quantity "I1-I2" using the
% command ".^2". The "." there tells Matlab to apply the operation "^2" to
% each one of the elements of the vector resulting from "I1-I2".
MeanPartitioningSquare=mean((I1-I2).^2);

% We can do this linear fit using the function "regress". Notice that this
% function only likes row vectors as an input. As a result we need to
% transpose our vectors using the command " ' "
alphaFit=regress(MeanPartitioningSquare',Itot');

% NOTE: If "regress" doesn't work with your version of Matlab one
% alternative if to use the code below to do a fit to a first-degree
% polynomial. If you wish to use that code you will have to uncomment the
% lines below (remove the "%") and run them. In this case there will be a
% small y-intercept, but we can safely ignore it as it small compared to
% the values in MeanPartitioningSquare.
% p=polyfit(Itot,MeanPartitioningSquare,1)
% alphaFit=p(1);

% Notice that our alphaFit value is very close to the actual value of alpha
% we dialed in. Let's plot everything together.


figure(2)
% The simulated data
plot(Itot,sqrt((I1-I2).^2),'.k');
hold on
% The mean partitioning error for each value of Itot
plot(Itot, sqrt(mean((I1-I2).^2)),'or','MarkerFaceColor','r');
% The result from the fit
plot(Itot,sqrt(alphaFit*Itot),'-b');
hold off
xlabel('I_1 + I_2 (au)')
ylabel('|I_1 - I_2|')



% As a result, as long as the assumptions of random partitioning apply, we
% will be able to infer the relation between number of fluorescent
% molecules and their actual fluorescence by just looking at fluctuations
% between daughter cells.


