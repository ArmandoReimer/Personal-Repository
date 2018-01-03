%Plot the prediction for the fold-change vs. R for different
%values of the binding energy

%Define a vector of R values using linspace. Linspace generates a vector of
%uniformly spaced points between a minimum and a maximum.
R=linspace(0,1000);

%Define the energies in kBT
E1=-10;
E2=-15;
E3=-20;
%Number of non-specific binding sites
Nns=5E6;

%Calculate the fold-chage. Note the placement of the "." in front of the
%division as a means to tell Matlab that it should carry out the operation
%for each element of the vector R.
fold1=1./(1+R/Nns*exp(-E1));
fold2=1./(1+R/Nns*exp(-E2));
fold3=1./(1+R/Nns*exp(-E3));

%Plot it on a linear scale
figure(1)
plot(R,fold1,'-k')
hold on
plot(R,fold2,'-r')
plot(R,fold3,'-g')
hold off
xlabel('number of repressors')
ylabel('fold-change')
legend('-10kBT','-15kBT','-20kBT')

%Plot it on a log scale
figure(2)
semilogx(R,fold1,'-k')
hold on
semilogx(R,fold2,'-r')
semilogx(R,fold3,'-g')
hold off
xlabel('number of repressors')
ylabel('fold-change')
legend('-10kBT','-15kBT','-20kBT')
xlim([0, 1000])










