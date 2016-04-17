function TFResponseGenerator()
amp1 = 1;
amp2 = 1;
offset1 = 1.2;
offset2 = 1.2;
t = linspace(1.5*pi,3*pi)';
t2 = linspace(3.5*pi, 8*pi)';
binding = (amp1*square(t,10)+offset1)/(amp1+offset1) + randn(size(t))/5;
transcription = (amp2*square(t,25)+offset2)/(amp2+offset2)+ randn(size(t))/5;
plot(t/pi,binding)
hold on
plot(t2/pi,transcription);
xlabel('t (100 ms)')
axis([0, 7,0, 1.3])
legend('Bicoid-GFP Channel', 'MCP-TagRFPt Channel')
ylabel('Intensity (A.U.)')
title('Example two-color response function')