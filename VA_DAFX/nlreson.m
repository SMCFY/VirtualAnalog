function y = nlreson(fc, bw, limit, x)
% function y = nlreson(fc, bw, limit, x)
% Authors: Välimäki, Bilbao, Smith, Abel, Pakarinen, Berners
%
% Parameters:
% fc = center frequency (in Hz)
% bw = bandwidth of resonance (in Hz)
% limit = saturation level
% x = input signal
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

fs = 44100;  % Sampling rate
R = 1 - pi*(bw/fs);  % Calculate pole radius
costheta = ((1+(R*R))/(2*R))*cos(2*pi*(fc/fs)); % Cosine of pole angle
a1 = -2*R*costheta;  % Calculate first filter coefficient
a2 = R*R;  % Calculate second filter coefficient
A0 = (1 - R*R)*sin(2*pi*(fc/fs)); % Scale factor
y = zeros(size(x));  % Allocate memory for output signal
w1 = 0; w2 = 0;  % Initialize state variables (unit delays)
y(1) = A0*x(1);  % The first input sample goes right through
w0 = y(1);  % Input to the saturating nonlinearity
for n = 2:length(x);  % Process the rest of input samples
    if y(n-1) > limit, w0 = limit;  % Saturate above limit
    elseif y(n-1) < -limit, w0 = - limit;  % Saturate below limit
    else w0 = y(n-1);end  % Otherwise do nothing
    w2 = w1;  % Update the second state variable
    w1 = w0;  % Update the first state variable
    y(n) = A0*x(n) - a1*w1 - a2*w2;  % Compute filter output
end