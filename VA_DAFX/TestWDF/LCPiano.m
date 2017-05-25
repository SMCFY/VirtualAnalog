% LCpiano
% [TREE]
% C1 capacitor	3.6e-4	0
% L1 inductor	3.6e-4	100
% 
% A1 S_adaptor	C1	L1
% R  resistor	0.01
% A2 S_adaptor	A1	R


Fs = 44100; % sample rate (Hz)
N = 20000; % number of samples to simulate

output = zeros(N,1);
 
CapVal1 = 1.6e-4; % the capacitance value in Farads
C1 = Capacitor(1/(2*CapVal1*Fs));
Lval1 = 3.6e-4;
L1 = Inductor(2*Lval1*Fs)
L1.State = 100;
 
 
A1 =  Series(C1,L1); % create WDF 

R = Resistor(0.01);

A2 = Series(A1,R);
  
for i=1:N
    myB = WaveUp(A2); 
    WaveDown(A2,-myB); % open circuit 
    output(i) = Voltage(C1);
end
plot(output)
soundsc(output, Fs)