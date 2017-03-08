% lagr2.m
% Authors: Välimäki, Bilbao, Smith, Abel, Pakarinen, Berners
% lagr.m -- Lagrange filter design script
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

fs=44100;
numtaps=8;   %% Make this even, please.
ordvec=[0:numtaps-1]';
VA=flipud(vander(ordvec)');
iVA=inv(VA); %matrix to compute coefs
numplots=16;
for ind=1:numplots
    eta=(ind-1)/(numplots-1);  %% fractional delay
    delay=eta+numtaps/2-1;  %% keep fract. delay between two center taps
    deltavec=(delay*ones(numtaps,1)).^ordvec; 
    b=iVA*deltavec;
    [H,w]=freqz(b,1,2000);
    figure(1)
    subplot(2,1,1)
    plot(w*fs/(2*pi),(abs(H)))
    grid on
    hold on
    xlabel('Freq, Hz')
    ylabel('magnitude')
    axis([0 fs/2 0 1.1])
    subplot(2,1,2)
    plot(w*fs/(2*pi),180/pi*unwrap(angle(H)))
    grid on
    hold on
    xlabel('Freq, Hz')
    ylabel('phase')
    xlim([0 fs/2])
end   
figure(1)
subplot(2,1,1);hold off;
title('Lagrange Interpolator')
subplot(2,1,2);hold off;