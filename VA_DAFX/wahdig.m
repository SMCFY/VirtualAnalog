% wahdig.m
% Authors: Välimäki, Bilbao, Smith, Abel, Pakarinen, Berners
% A = wahdig(fr,Q,fs)
% 
% Parameters:
% fr = resonance frequency (Hz)
% Q  = resonance quality factor
% fs = sampling frequency (Hz)
%
% Returned:
% A = [1 a1 a2] = digital filter transfer-function denominator poly
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------


frn = fr/fs;
R = 1 - PI*frn/Q; % pole radius
theta = 2*PI*frn; % pole angle
a1 = -2.0*R*cos(theta); % biquad coeff
a2 = R*R;               % biquad coeff