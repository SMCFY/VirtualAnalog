clear; clc
% C4 and L in parallel --> Series(P, R1) --> Parallel(S1, C2) --> Nonlinear Resistor

fs = 100000;
len = 10000; % length in samples

C2val = 49.5e-9;
C2 = Capacitor(1/(2*C2val*fs));
%C4.State = 20000;

Lval = 7.07e-3;
L1 = Inductor(2*Lval*fs);
% L1.State = 0.01;

P1 = Parallel(L1,C2);

R1 = Resistor(1428); % 1.428kOhm
% O1 = OpenCircuit(1428);
S1 = Series(P1, R1);

C1val = 5.5e-9;
C1 = Capacitor(1/(2*C1val*fs));
C1.State = 0.1;
%NLR = NLResistor(569.2);
P2 = Parallel(S1, C1);

%S1 = Series(P1, P2);


output = zeros(len,1);
% C1.State = 100;
 %C4.State = 100;
for i=1:len
    %L1.State = -1 + (1+1)*rand(1);
    a = WaveUp(P2); % get the waves up to the root
    %P2.WU
    %b = setWD(NLR, a);
    %NLR.WD
    
    %b = calNLRes(a);
    setWD(P2, calNLRes(a)); 
    %P2.WD
    output(i) = getState(C2);
    output2(i) = getState(C1);

end
%%
plot(output2, output)
%soundsc(output,fs)
