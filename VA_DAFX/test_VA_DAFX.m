[x,fs] = audioread('highpitchchords.wav');

%% Nonlinear resonator
fc = 1000;
bw = 1000;
limit = 0.1;

y1 = nlreson(fc,bw,limit,x);
sound(y1,fs)
%% Moogfilter
%[out,out2,in2,g,h0,h1] = moogvcf(in,fc,res)
res = 1;
[y2,y3,x2,g,h0,h1] = moogvcf(x,fc,res);
sound(y2',fs)

%% Bassman
low = 0.5; mid = 0.1; top = 1;
[y4,B0,B1,B2,B3,A0,A1,A2,A3] = bassman(low, mid, top, x);
sound(y4,fs)

%% Wah
% wah controls, 0-1
wah = 1;
[g,fr,Q] = wahcontrols(wah);
% A = wahdig(fr,Q,fs)
%
% Parameters:
% fr = resonance frequency (Hz)
% Q = resonance quality factor
% fs = sampling frequency (Hz) %
% Returned:
% A = [1 a1 a2] = digital filter transfer-function denominator poly
frn = fr/fs;
R = 1 - pi*frn/Q; % pole radius
theta = 2*pi*frn; % pole angle
a1 = -2.0*R*cos(theta); % biquad coeff 
a2 = R*R; % biquad coeff
y5 = filter(0.5,a2,x);
sound(y5,fs)