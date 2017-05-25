Fs = 44100; % sample rate (Hz)
N = 2000; % number of samples to simulate

t = 0:N-1; % time vector for the excitation
gain = 30; % input signal gain parameter
f0 = 20000; % excitation frequency (Hz)
input = gain.*sin(2*pi*f0/Fs.*t); % the excitation signal
output = zeros(N,1);
CapVal = 1e-9; % the capacitance value in Farads
C1 = Capacitor(1/(2*CapVal*Fs));
Lval = 1e-6;
L1 = Inductor(2*Lval*Fs);
%L1.State = 1;
%C1.State = 1;
R1 = Resistor(1000); % create the capacitance
s1 =  Series(L1,Parallel(C1,R1)); % create WDF tree as a ser. conn. of V1,C1, and R1
%r = 1/(2*pi*sqrt(CapVal*Lval)) % resonant frequency, from wiki: https://en.wikipedia.org/wiki/LC_circuit


outputR = zeros(N,1);
outputC = zeros(N,1);
outputL = zeros(N,1);

CapVal = 100e-8; % the capacitance value in Farads
C1 = Capacitor((1/Fs)/(2*CapVal));
Lval = 0.15;
L1 = Inductor(2*Lval/(1/Fs));
% L1.State = 1;
% C1.State = 1;
V1 = VoltageSource(0,1);
R1 = Resistor(12); % create the capacitance
s1 =  Series(L1,Series(C1,Series(V1,R1))); % create WDF tree as a ser. conn. of V1,C1, and R1

%r = 1/(2*pi*sqrt(CapVal*Lval)) % resonant frequency, from wiki: https://en.wikipedia.org/wiki/LC_circuit
% http://www.electronics-tutorials.ws/accircuits/series-circuit.html
gain = 10; % input signal gain parameter
f0 = 50; % excitation frequency (Hz)
t = 0:N-1; % time vector for the excitation
input = gain.*sin(2*pi*f0/Fs.*t); % the excitation signal
%input = audioread('highpitchchords.wav');
%Oc = OpenCircuit(1);


for i=1:N
    V1.E = input(i);
    
    WaveUp(s1); % get the waves up to the root

    WaveDown(s1,0); % open circuit structure b = 0?
    outputC(i) = Voltage(C1);
    outputL(i) = Voltage(L1);
    outputR(i) = Voltage(R1);
%     if rand(1) < 0.5
%         L1.State = L1.State + 0.1;
%     end
end

%% 
%plot(outputC,'b')
hold on; 

plot(outputL,'y')
plot(outputR,'r')
%plot(input(1:N),'k')
%soundsc(output, Fs)
%soundsc(input(1:N,1),Fs)
