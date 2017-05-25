% Tank circuit without an input. We are resonating with the current state
% of the inductor.

Fs = 44100; % sample rate (Hz)
N = Fs; % number of samples to simulate

output = zeros(N,1);

CapVal = 3.6e-4; % the capacitance value in Farads
C1 = Capacitor(1/(2*CapVal*Fs));

Lval = 3.6e-4;
L1 = Inductor(Fs/2*Lval);
L1.State = 100;

s1 =  Series(C1,L1); % create WDF tree as a ser. conn. of V1,C1, and R1
r = 1/(2*pi*sqrt(CapVal*Lval)) % resonant frequency, from wiki: https://en.wikipedia.org/wiki/LC_circuit

for i=1:N
    WU = WaveUp(s1); % get the waves up to the root
    WaveDown(s1,-WU); % open circuit structure b = 0?
    output(i) = getState(C1);

end
%% 
plot(output)
%soundsc(output, Fs)