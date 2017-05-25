clear; clc; close all;
Fs = 44100; % sample rate (Hz)
N = 2000; % number of samples to simulate

output = zeros(N,1);
InVal = 20e-3; % The value of the inductor in henri
L1 = Inductor(2*InVal*Fs);

V1 = VoltageSource(0,1);
R1 = Resistor(30); % create the capacitance
CapVal = 2e-6;
C1 = Capacitor(1/(2*CapVal*Fs));
s1 =  Series(V1,Series(R1,Series(L1,C1))); % create WDF tree as a ser. conn. of V1,C1, and R1
gain = 30; % input signal gain parameter
f0 = 100; % excitation frequency (Hz)
t = 0:N-1; % time vector for the excitation
input = gain.*sin(2*pi*f0/Fs.*t); % the excitation signal


for i=1:N
    V1.E = input(i);
    WaveUp(s1); % get the waves up to the root
    WaveDown(s1, 0); % open circuit structure b = 0?
    output(i) = Voltage(R1);
%     if rand(1) < 0.5
%         L1.State = L1.State + 0.1;
%     end
end
%% 
plot(output)
hold on; 
plot(input)
%soundsc(output, Fs)