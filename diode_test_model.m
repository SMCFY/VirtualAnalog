function [i, J] = diode_test_model(v)
% Model of single nonlinear diode
    % values are from master thesis sd-1
    % Reverse saturation current
    Is = 4e-9;
    % emission coefficient
    n = 1.65;
    % voltage at diode's terminal
    vd = v(1);
    % Therminal voltage
    vt = 50e-3;
    % single diode characteristic voltage out
    %id = -Is * (exp((vd/n*vt) - 1));
    % calculate jacobian
    %J = -Is * (1 / 2 / vt*exp(vd/n*vt)-1);

    %Anti-parallel Diodes? current
    id = -Is * (exp(vd/(2*vt)) - exp(-vd/(vt)));
    %Anti-parallel Diodes? jacobian
    J = -Is * (1/2/vt*exp(vd/(2*vt)) + 1/vt*exp(-vd/(vt)));
    i = id;
end