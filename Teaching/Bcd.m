% Embryo = imread('1xBcd.tif');
% imshow(Embryo)
% %click on the embryo and save the inputs
% %clicks = ginput;
% %each column in click corresponds to a given click. the first column is the
% %x position and the second column is the y position
% hold on
% plot(clicks(:,1), clicks(:,2), '.-r')
% delta = diff(clicks)
% deltasq = delta.^2
% dssq = sum(deltasq,2)
% ds = sqrt(dssq)
% %total length
% s = sum(ds)
% cflength = sum(ds(1:7))
% cflength/s

figure
%create a range of d values with linspace
d = linspace(.3, 2.5);
xNew = .19*log(d) + .32;
semilogx(d, xNew)
xlabel('Dosage')
ylabel('xNew')
hold on
ddata = [.5, 1, 2];
xData = [.26, .32, .36];
semilogx(ddata, xData,'o')
hold off
