Fs = 44100; % sample rate (Hz)
N = 40000; % number of samples to simulate

output = zeros(N,1);

CapVal = 3.5e-2; % the capacitance value in Farads
C1 = Capacitor(1/(2*CapVal*Fs));

Lval = 3.6e-5;
L1 = Inductor(Fs/2*Lval);
L1.State = 100;

R1 = Resistor(2);
s1 =  Series(C1,Parallel(L1,R1)); 

for i=1:N
    b = WaveUp(s1); % get the waves up to the root
    WaveDown(s1,-b);
    output(i) = getState(C1);
end

plot(output)
soundsc(output, Fs)