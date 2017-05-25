clear; clc
% Chua circuit
% C2 and L in parallel --> Series(P, R1) --> Parallel(S1, C1) --> Nonlinear Resistor

fs = 100000; % T = 10uS
len = 10000; % length of output in samples
output = zeros(len,1);

% Capacitor C2
C2val = 49.5e-9;
C2 = Capacitor(1/(2*C2val*fs)); 
% Inductor L1
Lval = 7.07e-3;
L1 = Inductor(2*Lval*fs);
% Initialise L1 with a small voltage to excite the circuit
L1.State = 0.1;
% Connect inductor L1 and capacitor C2 in parallel
P1 = Parallel(L1,C2);
% Resistor R1
R1 = Resistor(1428); % 1.428kOhm
% Series connection between parallel adaptor P1 and resistor R1
S1 = Series(P1, R1);
% Capacitor C1 
C1val = 5.5e-9;
C1 = Capacitor(1/(2*C1val*fs));
% Parallel connection between S1 and C1, Serves as the adaptor at the "top"
% of the tree
P2 = Parallel(S1, C1);

for i=1:len
    a = WaveUp(P2);           % get the waves up to the root
    WaveDown(P2, ChuaResistor(a));   % Send the NL in the resistor down the tree
    output(i) = getState(C2); % Get the state at component C2
    output2(i) = getState(C1);% Get the state at component C1
end
%%
plot(output2, output)
xlabel('Voltage over C1')
ylabel('Voltage over C2')
title('Chua Circuit', 'FontSize', 18 )
