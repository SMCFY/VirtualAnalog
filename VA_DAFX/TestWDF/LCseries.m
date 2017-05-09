Fs = 44100; % sample rate (Hz)
N = Fs/10; % number of samples to simulate

output = zeros(N,1);
CapVal = 3.5e-5; % the capacitance value in Farads
C1 = Capacitor(1/(2*CapVal*Fs));
Lval = 3.5e-2;
L1 = Inductor(1/(2*Lval*Fs));
L1.State = 1000;
%R2 = Resistor(160); % create the capacitance
s1 =  Series(C1,L1); % create WDF tree as a ser. conn. of V1,C1, and R1
r = 1/(2*pi*sqrt(CapVal*Lval)) % resonant frequency, from wiki: https://en.wikipedia.org/wiki/LC_circuit

Oc = OpenCircuit(1);


for i=1:len
    WaveUp(s1); % get the waves up to the root
    s1.WU
    Oc.WD = s1.WU;
    setWD(s1, Oc.WD); % open circuit structure b = a
    output(i) = Voltage(C1);
end
%% 
plot(output)