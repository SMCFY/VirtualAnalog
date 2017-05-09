
% C4 and L in parallel --> Series(P, OpenCircuit) --> Parallel(S, C2) --> Nonlinear Resistor
fs = 44100;
len = 20000; % length in samples
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
C1.State = 100; 
C4.State = 100; 
L1.State = 100; 
for i=1:len
    WaveUp(P2); % get the waves up to the root
    setWD(NLR, P2.WU);
    setWD(P2,NLR.WD); 
    output(i) = Voltage(C1);

end
%%
plot(output)
