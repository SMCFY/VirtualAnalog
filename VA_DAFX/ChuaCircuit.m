clear; clc
% C4 and L in parallel --> Series(P, R1) --> Parallel(S1, C2) --> Nonlinear Resistor
us = 10e-5;
fs = 1/us;
len = 20000; % length in samples

C4val = 49e-5;
C4 = Capacitor(1/(2*C4val*fs));
%C4.State = 20000;

Lval = 7.07e-2;
L1 = Inductor(2*Lval*fs);
L1.State = 1;

P1 = Parallel(C4,L1);

R1 = Resistor(0.1428); % 1.428kOhm
O1 = OpenCircuit(1428);
S1 = Series(P1, R1);

C1val = 5.5e-3;
C1 = Capacitor(1/(2*C1val*fs));
%C1.State = 200000;
%NLR = NLResistor(569.2);
P2 = Parallel(S1, C1);

%S1 = Series(P1, P2);


output = zeros(len,1);
% C1.State = 100;
 %C4.State = 100;
for i=1:len
    a = WaveUp(P2); % get the waves up to the root
    %P2.WU
    %b = setWD(NLR, a);
    %NLR.WD
    
    %b = calNLRes(a);
    setWD(P2, a); 
    %P2.WD
    output(i) = Voltage(C4);
    output2(i) = Voltage(C1);

end
%%
plot(output)
%soundsc(output,fs)
