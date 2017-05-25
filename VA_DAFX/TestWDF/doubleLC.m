% from BCT 
% Double LC parallel circuit.
% The voltages of the 2 oscillators sums and realize 
% some sort of "additive synthesis"

% [TREE]
% C1 capacitor	3.6e-4	0
% L1 inductor	3.6e-4	10
% A1 P_adaptor	C1	L1
% 
% C2 capacitor	4.6e-4	0
% L2 inductor	4.6e-4	10
% A2 P_adaptor	C2	L2
% 
% A3 S_adaptor	A1	A2
% Tank circuit without an input. We are resonating with the current state
% of the inductor. We are not using short or open circuit two ports,

Fs = 44100; % sample rate (Hz)
N = 20000; % number of samples to simulate
 
output = zeros(N,1);
 
CapVal1 = 3.6e-4; % the capacitance value in Farads
C1 = Capacitor(1/(2*CapVal1*Fs));
Lval1 = 3.6e-4;
L1 = Inductor(2*Lval1*Fs)
L1.State = 10;
 
 
p1 =  Parallel(C1,L1); % create WDF 

CapVal2 = 4.6e-4; % the capacitance value in Farads
C2 = Capacitor(1/(2*CapVal2*Fs));
Lval2 = 4.6e-4;
L2 = Inductor(2*Lval2*Fs)

L2.State = 10;

p2 =  Parallel(C2,L2); % create WDF 

s1 = Series(p1,p2);
  
for i=1:N
    myB = WaveUp(s1); 
    WaveDown(s1,myB); % open circuit 
    output(i) = Voltage(p1) +  Voltage(p2);
end
plot(output)
%soundsc(output, Fs)