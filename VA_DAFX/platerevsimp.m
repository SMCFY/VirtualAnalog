% platerevsimp.m
% Authors: Välimäki, Bilbao, Smith, Abel, Pakarinen, Berners
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

% global parameters
[f, SR] = wavread('bassoon.wav');   % read input soundfile and sample rate
rho = 7850;                         % mass density (kg/m^3)
E = 2e11;                           % Young's modulus (Pa)
nu = 0.3;                           % Poisson's ratio (nondimensional)
H = 0.0005;                         % thickness (m)
Lx = 1;                             % plate side length---x (m)
Ly = 2;                             % plate side length---y (m)
T60 = 8;                            % 60 dB decay time (s)
TF = 1;                             % extra duration of simulation (s)
ep = [0.5 0.4];                     % center location ([0-1,0-1]) nondim.
rp = [0.3 0.7];                     % position of readout([0-1,0-1]) nondim.
% derived parameters
K_over_A = sqrt(E*H^2/(12*rho*(1-nu^2)))/(Lx*Ly);  % stiffness parameter/area
epsilon = Lx/Ly;                     % domain aspect ratio
T = 1/SR;                            % time step
NF = floor(SR*TF)+size(f,1);         % total duration of simulation (samples)
sigma = 6*log(10)/T60;               % loss parameter
% stability condition/scheme parameters
X = 2*sqrt(K_over_A*T);             % find grid spacing, from stability cond.
Nx = floor(sqrt(epsilon)/X);        % number of x-subdivisions/spatial domain
Ny = floor(1/(sqrt(epsilon)*X));    % number of y-subdivisions/spatial domain
X = sqrt(epsilon)/Nx;               % reset grid spacing          
ss = (Nx-1)*(Ny-1);                 % total grid size
% generate scheme matrices
Dxx = sparse(toeplitz([-2;1;zeros(Nx-3,1)]));
Dyy = sparse(toeplitz([-2;1;zeros(Ny-3,1)]));
D = kron(speye(Nx-1), Dyy)+kron(Dxx, speye(Ny-1)); DD = D*D/X^4; 
B = sparse((2*speye(ss)-K_over_A^2*T^2*DD)/(1+sigma*T));
C = ((1-sigma*T)/(1+sigma*T))*speye(ss);  
% generate I/O vectors 
rp_index = (Ny-1)*floor(rp(1)*Nx)+floor(rp(2)*Ny);
ep_index = (Ny-1)*floor(ep(1)*Nx)+floor(ep(2)*Ny);
r = sparse(ss,1); r(ep_index) = T^2/(X^2*rho*H);
q = sparse(ss,1); q(rp_index) = 1;
% initialize state variables and input/output
u = zeros(ss,1); u2 = u; u1 = u;
f = [f;zeros(NF-size(f,1),1)];
out = zeros(NF,1);
% main loop
for n=1:NF
    u = B*u1-C*u2+r*f(n);   % difference scheme calculation
    out(n) = q'*u;          % output
    u2 = u1; u1 = u;        % shift data
end 
% play input and output
soundsc(f,SR); pause(2); soundsc(out,SR);