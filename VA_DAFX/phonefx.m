function [y, ylin] = phonefx(alpha, noise, x)
% function [y, ylin] = phonefx(alpha, noise, x)
% Authors: Välimäki, Bilbao, Smith, Abel, Pakarinen, Berners
%
% Parameters:
% alpha = nonlinearity factor (alpha >= 0)
% noise = noise level (e.g. noise = 0.01)
% x = input signal
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

fs = 44100;  % Sample rate
u = filter([0.9 zeros(1,10) -0.75],1,x);  % Pre-filter
[B,A] = cheby2(6,40,[234/(fs/2) 4300/(fs/2)]);  % Telephone line filter 
w = 2*rand(size(x))-1;  % White noise generation
y1 = (1-alpha)*u + alpha*u.^2 ;  % Carbon mic nonlinearity
y2 = y1 + noise*w;    % Add scaled white noise
y = filter(B,A,y2);    % Apply telephone line filter
ylin = filter(B,A,u);  % Linear filtering only (for comparison)