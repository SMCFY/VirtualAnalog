% Tank circuit without an input. We are resonating with the current state
% of the inductor. We are not using short or open circuit two ports,

Fs = 44100; % sample rate (Hz)
N = 20000; % number of samples to simulate
 
output = zeros(N,1);
 
CapVal = 3.6e-4; % the capacitance value in Farads
C1 = Capacitor(1/(2*CapVal*Fs));
 
Lval = 3.6e-4;
L1 = Inductor(Fs/2*Lval);

L1.State = 1;
 
p1 =  Parallel(C1,L1); % create WDF 
r = 1/(2*pi*sqrt(CapVal*Lval)) % resonant frequency, from wiki: https://en.wikipedia.org/wiki/LC_circuit

for i=1:N
    myB = WaveUp(p1); 
    WaveDown(p1,myB); % open circuit b[n] = a[n] 
    output(i) = Voltage(C1);
end
plot(output)
%soundsc(output, Fs)