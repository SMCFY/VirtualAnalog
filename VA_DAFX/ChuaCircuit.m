clear; clc
% C4 and L in parallel --> Series(P, R1) --> Parallel(S1, C2) --> Nonlinear Resistor
fs = 44100;
len = 1000; % length in samples
C4val = 49e-5;
C4 = Capacitor(1/(2*C4val*fs));
Lval = 7.07e-2;
L1 = Inductor(1/(2*Lval*fs));
P1 = Parallel(C4,L1);
R1 = Resistor(1428); % 1.428kOhm
S1 = Series(P1, R1);
C1val = 5.5e-3;
C1 = Capacitor(1/(2*C1val*fs));
P2 = Parallel(S1, C1);
NLR = NLResistor(569.2);
output = zeros(len,1);
% L1.State = 1;
% C1.State = 1;
% C4.State = 1;
for i=1:len
    WaveUp(P2); % get the waves up to the root
    %P2.WU
    setWD(NLR, P2.WU);
    %NLR.WD
    setWD(P2,NLR.WD); 
    %P2.WD
    output(i) = Voltage(R1);

end
%%
plot(output)
