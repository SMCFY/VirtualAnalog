Fs = 44100; % sample rate (Hz)
N = Fs; % number of samples to simulate
t = 0:N-1; % time vector for the excitation
gain = 30; % input signal gain parameter
f0 = 80; % excitation frequency (Hz)
input = gain.*sin(2*pi*f0/Fs.*t); % the excitation signal
output = zeros(N,1);
CapVal = 120e-12; % the capacitance value in Farads
C1 = Capacitor(1/(2*CapVal*Fs));
%C1.State = 1;
vol = 0.5;
Rt = Resistor((1-vol)*1e6);
Rv = Resistor(vol*1e6);
Vs = TerminatedVs(0,100*1e3);
p1 = ParallelSwitch(Parallel(Rt,Series(Vs,Rv)),C1); % create WDF tree as a ser. conn. of V1,C1, and R1
sw = 0;
for i=1:N
    if i > N/2 && sw == 0
        sw = 1;
        changeState(p1);
    end
    Vs.E = input(i);
    cycleWave(p1,0)
    output(i) = Voltage(Rv);

end
%% 
plot(input);hold on;
plot(output)
%soundsc(output, Fs)