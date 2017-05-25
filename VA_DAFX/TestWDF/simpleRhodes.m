% from BCT
% The simplest Hammer/Tine model
% [TREE]
% % Resonator is a LRC series circuit.
% Lt	inductor	0.0022		0
% Ct	capacitor	5.947e-5	0
% A1	S_adaptor	Lt		Ct
% Rt	resistor	0.01
% A2	S_adaptor	A1		Rt
% 
% % Hammer
% Lm	inductor	0.001		-2
% A3	P_adaptor	Lm		A2
Fs = 44100;
N = 40000; 

% Resonator
Lt = Inductor(2 * 0.0022 * Fs)
Ct = Capacitor(1/(2 * 15.947e-5 * Fs))
A1 = Series(Lt, Ct);

Rt = Resistor(0.04)
A2 = Series(A1, Rt)

% Hammer
Lm = Inductor(2 * 0.001 * Fs)
Lm.State = -2;
A3 = Parallel(Lm,A2);

for i=1:N
    myB = WaveUp(A3); 
    WaveDown(A3,myB); % open circuit 
    output(i) = getState(Ct);
end

plot(output)

%%
soundsc(output, Fs)