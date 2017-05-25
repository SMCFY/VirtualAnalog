Fs = 44100; % sample rate (Hz)
N = 20000; % number of samples to simulate

output = zeros(N,1);
CapVal = 3.1e-10; % the capacitance value in Farads
C1 = Capacitor(1/(2*CapVal*Fs));
%Lval = 3.5e-5;
%L1 = Inductor(1/(2*Lval*Fs));
%L1.State = 1;
C1.State = 1;
R1 = Resistor(60); % create the capacitance
p1 =  Parallel(C1,R1); % create WDF tree as a ser. conn. of V1,C1, and R1
%r = 1/(2*pi*sqrt(CapVal*Lval)) % resonant frequency, from wiki: https://en.wikipedia.org/wiki/LC_circuit

%Oc = OpenCircuit(1);


for i=1:N
    WaveUp(p1); % get the waves up to the root
    WaveDown(p1,0); % open circuit structure b = 0?
    output(i) = Voltage(C1);
%     if rand(1) < 0.5
%         L1.State = L1.State + 0.1;
%     end
end
%% 
plot(output)
soundsc(output, Fs)