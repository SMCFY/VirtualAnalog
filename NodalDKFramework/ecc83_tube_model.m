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