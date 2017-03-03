function [g,fr,Q] = wahcontrols(wah)
% Authors: V ?alima ?ki, Bilbao, Smith, Abel, Pakarinen, Berners
% function [g,fr,Q] = wahcontrols(wah) %
% Parameter: wah = wah-pedal-angle normalized to lie between 0 and 1
g = 0.1*4^wah; % overall gain for second-order s-plane transfer funct. 
fr = 450*2^(2.3*wah); % resonance frequency (Hz) for the same transfer funct. 
Q = 2^(2*(1-wah)+1); % resonance quality factor for the same transfer funct.