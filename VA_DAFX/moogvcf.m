function [out,out2,in2,g,h0,h1] = moogvcf(in,fc,res)
% function [out,out2,in2,g,h0,h1] = moogvcf(in,fc,res)
% Authors: Välimäki, Bilbao, Smith, Abel, Pakarinen, Berners
% Parameters:
% in = input signal
% fc= cutoff frequency (Hz)
% res = resonance (0...1 or larger for self-oscillation)
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

fs = 44100;  % Input and output sampling rate
fs2 = 2*fs;  % Internal sampling rate
% Two times oversampled input signal:
in = in(:); in2 = zeros(1,2*length(in)); in2(1:2:end) = in; 
h = fir1(10,0.5); in2 = filter(h,1,in2);  % Anti-imaging filter
Gcomp = 0.5;  % Compensation of passband gain
g = 2*pi*fc/fs2;  % IIR feedback coefficient at fs2
Gres = res;  % Direct mapping (no table or polynomial)
h0 = g/1.3; h1 = g*0.3/1.3; % FIR part with gain g
w = [0 0 0 0 0]; % Five state variables
wold = [0 0 0 0 0];  % Previous states (unit delays)
out = zeros(size(in)); out2 = zeros(size(in2));
for n = 1:length(in2),
    u = in2(n) - 4*Gres*(wold(5) - Gcomp*in2(n));  % Input and feedback
    w(1) = tanh(u);  % Saturating nonlinearity
    w(2) = h0*w(1) + h1*wold(1) + (1-g)*wold(2);  % First IIR1
    w(3) = h0*w(2) + h1*wold(2) + (1-g)*wold(3);  % Second IIR1
    w(4) = h0*w(3) + h1*wold(3) + (1-g)*wold(4);  % Third IIR1
    w(5) = h0*w(4) + h1*wold(4) + (1-g)*wold(5);  % Fourth IIR1
    out2(n) = w(5);  % Filter output
    wold = w;  % Data move (unit delays)
end
out2 = filter(h,1,out2);  % Antialiasing filter at fs2
out = out2(1:2:end);  % Decimation by factor 2 (return to original fs)