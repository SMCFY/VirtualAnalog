Fs = 44100; % sample rate (Hz)
N = 80000; % number of samples to simulate

t = 0:N-1; % time vector for the excitation
gain = 30; % input signal gain parameter
f0 = 20000; % excitation frequency (Hz)
input = gain.*sin(2*pi*f0/Fs.*t); % the excitation signal

output = zeros(N,1);

CapVal = 3.5e-2; % the capacitance value in Farads
C1 = Capacitor(1/(2*CapVal*Fs));

Lval = 3.6e-5;
L1 = Inductor(2*Lval*Fs);
L1.State = 1;
%L1.State = 1;
%C1.State = 1;
R1 = Resistor(80); % create the capacitance
s1 =  Series(C1,Parallel(L1,R1)); % create WDF tree as a ser. conn. of V1,C1, and R1
%r = 1/(2*pi*sqrt(CapVal*Lval)) % resonant frequency, from wiki: https://en.wikipedia.org/wiki/LC_circuit

%Oc = OpenCircuit(1);


for i=1:N
   b = WaveUp(s1); % get the waves up to the root
    setWD(s1,-b); 
    output(i) = getState(C1);
end
%% 

plot(output)
soundsc(output, Fs)