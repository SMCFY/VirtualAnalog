Fs = 44100; % sample rate (Hz)
N = 20000; % number of samples to simulate

output = zeros(N,1);
CapVal = 3.1e-2; % the capacitance value in Farads
C1 = Capacitor(1/(2*CapVal*Fs));
Lval = 3.5e-3;
L1 = Inductor(Fs/Lval*2);
%L1.State = 1;
%C1.State = 1;
R1 = Resistor(160); % create the capacitance
s1 =  Series(R1,Series(C1,L1)); % create WDF tree as a ser. conn. of V1,C1, and R1
%r = 1/(2*pi*sqrt(CapVal*Lval)) % resonant frequency, from wiki: https://en.wikipedia.org/wiki/LC_circuit

%Oc = OpenCircuit(1);

gain = 30; % input signal gain parameter
f0 = 100; % excitation frequency (Hz)
t = 0:N-1; % time vector for the excitation
input = gain.*sin(2*pi*f0/Fs.*t); % the excitation signal

for i=1:N
    WaveUp(s1); % get the waves up to the root
    WaveDown(s1,input(i)); % open circuit structure b = 0?
    output(i) = getState(C1);
%     if rand(1) < 0.5
%         L1.State = L1.State + 0.1;
%     end
end
%% 
plot(output)
%soundsc(output, Fs)