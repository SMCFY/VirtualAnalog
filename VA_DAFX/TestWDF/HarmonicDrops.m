% BCT
% Harmonic Drops
% [TREE]
% V1	resistor	1
% 
% C2a	capacitor	3.2884e-6	0
% L2a	inductor	39.789e-3	0
% A1	S_adaptor	C2a	L2a
% 
% C1	capacitor	19.894e-6	0
% L1	inductor	6.5768e-3	100
% A2	P_adaptor	C1	L1
% 
% C2b	capacitor	3.2884e-6	0
% L2b	inductor	39.789e-3	0
% A3	S_adaptor	C2b	L2b
% 
% A4	P_adaptor	V1	A1
% A5	S_adaptor	A4	A2
% A6	P_adaptor	A5	A3
% 
% Lf	inductor	3.6e-3	0
% Cf	capacitor	3.6e-4	0
% A7	S_adaptor	A6	Lf
% A8	P_adaptor	A7	Cf

Fs = 44100; % sample rate (Hz)
N = 40000; % number of samples to simulate

output = zeros(N,1);

V1 = Resistor(1);
C2a = Capacitor(1/(2*3.2884e-6*Fs));
L2a = Inductor(2*39.789e-3*Fs);
A1 = Series(C2a, L2a);

C1 = Capacitor(1/(2*19.894e-6*Fs));
L1 = Inductor(2*6.5768e-3*Fs);
L1.State = 100;
A2 = Parallel(C1, L1);

C2b	= Capacitor(1/(2*3.2884e-6*Fs));
L2b	= Inductor(2*39.789e-3*Fs);
A3 = Series(C2b, L2b);

A4 = Parallel(V1, A1);
A5 = Series(A4, A2);
A6 = Parallel(A5, A3);

Lf = Inductor(2*3.6e-3*Fs);
Cf = Capacitor(1/(2*3.6e-4*Fs));
A7 = Series(A6,	Lf);
A8 = Parallel(A7, Cf);

for i=1:N
    myB = WaveUp(A8); 
    WaveDown(A8,myB); % open circuit 
    output(i) = Voltage(A6);
end
plot(output)
soundsc(output, Fs)
