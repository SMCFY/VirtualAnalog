% WDFDiodeExample.m
% Authors: Välimäki, Bilbao, Smith, Abel, Pakarinen, Berners
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------
Fs = 20000; % sample rate (Hz)
N = 1000; % number of samples to simulate
gain = 2; % input signal gain parameter
f0 = 100; % excitation frequency (Hz)
t = 0:N-1; % time vector for the excitation
input = gain.*sin(2*pi*f0/Fs.*t); % the excitation signal

output = zeros(1,length(input));

V1 = VoltageSource(0,1); % create a source with 0 (initial) voltage and 1 Ohm ser. res.
R1 = Resistor(80); % create an 80Ohm resistor

CapVal = 3.5e-5; % the capacitance value in Farads
C1 = Capacitor(1/(2*CapVal*Fs)); % create the capacitance
s1 =  Series(V1,Series(C1,R1)); % create WDF tree as a ser. conn. of V1,C1, and R1
Vdiode = 0; % initial value for the voltage over the diode

Is = 2.52e-9;
Vt = 45.3e-3;

Rp = (s1.PortRes*C1.PortRes)/(s1.PortRes+C1.PortRes);
maxIter = 1000;
dx = 1e-6;
b2 = [];
b = 0; %initial guess
%% The simulation loop:
for n = 1:N % run each time sample until N
    %n
    V1.E = input(n); % read the input signal for the voltage source
    WaveUp(s1); % get the waves up to the root
    %Rdiode = 125.56*exp(-0.036*Vdiode); % the nonlinear resist. of the diode
    %eq = 2*Is*sinh(Vdiode+b)/(2*Vt)-(Vdiode-b)/(Rp);
    %estb = vpasolve(eq,b);
    %r = (Rdiode-s1.PortRes)/(Rdiode+s1.PortRes); % update scattering coeff.
    iter = 1;
    while (iter < maxIter)
        f = 2*Is*sinh((Vdiode)/(2*Vt)) - (Vdiode-2*b)/(2*Rp);
        df = 2*Is*sinh((Vdiode)/(2*Vt)) - (Vdiode-(2*b+dx))/(2*Rp);
        newB = b - (dx*f)/(df - f);
        b = newB;
        iter = iter + 1;
    end
    b2(n) = b;
    WaveDown(s1, b); % evaluate the wave leaving the diode (root element)
    Vdiode = (s1.WD+s1.WU)/2; % update the diode voltage for next time sample
    output(n) = Voltage(R1); % the output is the voltage over the resistor R1
end; 
%% Plot the results
t = (1:length(input))./Fs; % create a time vector for the figure
hi = plot(t,input,'--'); hold on; % plot the input signal, keep figure open
ho = plot(t,output); hold off; % plot output signal, prevent further plots
grid on; % use the grid for clarity
xlabel('Time (s)'); ylabel('Voltage (V)'); % insert x- and y-axis labels
legend([hi ho],'Source voltage E','Voltage over R1'); % insert legend