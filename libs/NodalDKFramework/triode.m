%  NodalDKFramework
%  Digital simulation of analog circuits
% 
%  Jaromir Macak
%  jarda.macak@seznam.cz
% 
%  14.1.2017
% 
%  Copyright 2017, All Rights Reserved.
%  
%  This software may be licensed under the terms of the
%  GNU Public License v3 (LICENSE-gpl3.txt) or the custom license
% (LICENSE.txt) located at the root of the source distribution.
%  These files may also be found in the public source
%  code repository located at:
%         https://github.com/jardamacak/NodalDKFramework

function obj = triode(name__, nodes__, model__)
obj.nodes = zeros(2,2); % some components can be two-ports like this
    obj.name = zeros(1,8);  % the name must have the same length 
    l = min(8,length(name__));
    obj.nodes(1:2,:) = nodes__; % set the nodes - two-port 
    obj.name(1:l) = name__(1:l); % set the name
    obj.value = 0; % set the value
    obj.type = 'trd'; % 3char ID
    obj.model = '';
  %  switch(obj.model)
  %      case 'ecc83'
  %          obj.model = @ecc83_tube_model;
  %      case '12ax7'
  %          obj.model = @ecc83_tube_model;
  %  end
end

function [i, J] = ecc83_tube_model(v)
% source: Kristjan Dempwolf and Udo Zölzer, A PHYSICALLY-MOTIVATED TRIODE MODEL FOR CIRCUIT SIMULATIONS
    Gg = 606e-6;
    xi = 1.354;
    Cg = 13.9;
    vgk = v(1); 
    vpk = v(2);
    expg = exp(Cg*vgk);
    ig = -Gg * (log(1+expg)/Cg)^xi;
    dig_dvgk = -Gg * xi * (log(1+expg)/Cg)^(xi-1) * expg/(1+expg);
    dig_dvpk = 0;

    Gp = 2.14e-3;
    gamma = 1.303;
    Cp = 3.04;
    mu = 100.8;
    expp = exp(Cp*(vpk/mu+vgk));
    ip = -Gp * (log(1+expp)/Cp)^gamma - ig;
    dip_dvgk = -Gp * gamma * (log(1+expp)/Cp)^(gamma-1) * expp/(1+expp);
    dip_dvpk = dip_dvgk/mu;
    
    i = [ig; ip];
    J = [dig_dvgk, dig_dvpk; dip_dvgk, dip_dvpk];
end

