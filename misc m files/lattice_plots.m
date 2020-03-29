
% for i = 1:length(CompiledParticles)
%     if length(CompiledParticles(i).Frame) > 150 %only show long-lived particle traces
        figure(1)
        ElapsedTime = ElapsedTime.*0;
        for i = 1:length(ElapsedTime)
            ElapsedTime(i) = .0455 * i;
        end
        z = AllTracesVector(:,2);
       %z = AllTracesVector(:,2);

        y1 = z(~isnan(z));
        x1 = ElapsedTime(~isnan(z));
%         y2 = CompiledParticles(2).Off.*109;
        
        semilogy(x1,y1)
            title('Lattice light sheet active transcription (P2 Promoter)')
%        title('Confocal active transcription (P2 Promoter)')
       
ylabel('Intensity (A.U.)');
        xlabel('Elapsed Time (min)');
        hold on 
%         hold on
%         plot(x1,y2)
        
%         legend('MCP-GFP Signal', 'Background')
        
        figure(2)
        Y = fft(y1);
        L = length(y1); %number of points in my signal
        Fs = 1/(ElapsedTime(1)); %sampling frequency in Hz
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f = Fs*(0:(L/2))/L;
        plot(f,P1)
        title('Single-Sided Amplitude Spectrum of Transcription Trace')
        xlabel('f (Hz)')
        ylabel('|P1(f)|')
        %ylim = [0,5*10^4]
        %xlim = [0,.08]
        
        figure(3)
        [acor, lag] = xcorr(y1);
%         lag = lag.*2.37;
        lag = lag.*(ElapsedTime(1)/60);
        plot(lag, acor);
        
        title('Autocorrelation of Transcription Trace')
        xlabel('Delay (s)')
        ylabel('Correlation')
        
%     end
% end
% figure(2)
% SBR = [];
% SNR = [];
% SBR = MeanVectorAll ./ MeanOffsetVector;
% SNR = MeanVectorAll ./ SDOffsetVector;
% plot(ElapsedTime, SBR, ElapsedTime, SNR)
% title('Signal quality- lattice light sheet P2P')
% ylabel('Ratio');
% xlabel('Elapsed Time (s)');
% legend('SBR', 'SNR')
% 
% figure(3)
% scatter(MeanOffsetVector, SDOffsetVector)
% title('Signal quality- lattice light sheet P2P')
% ylabel('StDevBackground');
% xlabel('<Background>');
 



        