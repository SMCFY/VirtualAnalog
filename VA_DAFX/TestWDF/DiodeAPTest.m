clear; clc;
% Anti Parallel Diode Circuit 
% As described in 
Fs = 48000; % sample rate (Hz)
N = 16000; % number of samples to simulate
gain = 4.5; % input signal gain parameter
f0 = 80; % excitation frequency (Hz)
t = 0:N-1; % time vector for the excitation
input = gain.*sin(2*pi*f0/Fs.*t); % the excitation signal

output = zeros(1,length(input));

% Device parameters for the following simulations are
% Rs = 2.2kOhm, Ch = 0.47uF, Cl = 0.01uF, Is = 2.52 × 10-9 A, and Vt = 45.3mV.
% Terminated voltage source V1
V1 = TerminatedVs(0, 2200);

% Capacitor C1 with Ch value
Ch = 0.47e-6; % the capacitance value in Farads
C1 = Capacitor(1/(2*Ch*Fs)); % create the capacitance

% Capacitor C2 with Cl value
Cl = 0.01e-6;
C2 = Capacitor(1/(2*Cl*Fs));

% Connect V1 and C1 in series
A1 = Series(V1,C1);

% Connect A1 and C2 in parallel
A2 = Parallel(A1, C2);

% Physical diode parameters 
Is = 2.52e-9;
Vt = 45.3e-3;
% Diode port resistance 
Rp = (A2.PortRes*C2.PortRes)/(A2.PortRes+C2.PortRes);

% Initialising values for newton-raphson algorithm
maxIter = 10;   % maximun number of iterations
dx = 1e-6;      % delta x
err =  1e-6;    % error 
epsilon = 1e-9; % a value close to 0 to stop the iteration if the equation is converging
b2 = [];
b = 0;          % initial guess
%% The simulation loop:
for n = 1:N % run each time sample until N
    V1.E = input(n); % read the input signal for the voltage source
    a = WaveUp(A2);  % get the waves up to the root

    iter = 1;        % reset iter to 1
    % Newton-Raphson algorithm
    while (abs(err) / abs(b) > epsilon )   
        f = 2*Is*sinh((a + b)/(2*Vt)) - (a - b)/(2*Rp);
        df = 2*Is*sinh((a + (b+dx))/(2*Vt)) - (a-(b+dx))/(2*Rp);
        newB = b - (dx*f)/(df - f); % generate a new b
        b = newB;
        iter = iter + 1;
        if (iter > maxIter)         % if iter is larger than the maximum nr of iterations  
            break;                  % break out from the while loop
        end       
    end
    b2(n) = b;
    WaveDown(A2, b);            % evaluate the wave leaving the diode (root element)
    output(n) = Voltage(A2); % the output is the voltage over the parallel adaptor A2
end
%% Plot the results
t = (1:length(input))./Fs; % create a time vector for the figure
%hi = plot(t,input,'--'); hold on; % plot the input signal, keep figure open
ho = plot(t,output);  % plot output signal, prevent further plots
grid on; % use the grid for clarity
xlabel('Time (s)'); ylabel('Voltage (V)'); % insert x- and y-axis labels
%legend([hi ho],'Source voltage E','Voltage over R1'); % insert legend
title('Two-Capacitor Diode Clipper','FontSize',18)