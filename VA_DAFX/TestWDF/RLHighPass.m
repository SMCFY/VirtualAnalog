%% Inductive High Pass filter
% From Fundamentals of Electrical Engineering and Electronics 
% by T.R.Kuphaldt et al

Fs = 44100; % sample rate (Hz)
N = 4000; % number of samples to simulate
output = zeros(N,1);

% Sinusoidal signal input
t = 0:N-1; % time vector for the excitation
gain = 30; % input signal gain parameter
f0 = 20; % excitation frequency (Hz)
input = gain.*sin(2*pi*f0/Fs.*t);

% Chirpt signal input
%fchirp = 20;
%t=0:1/Fs:100000/Fs;
%for ii=1:N
%     input(ii) = gain*sin(2*pi*fchirp^t(ii)); % chirp signal
%end

% Create the circuit
V1 = VoltageSource(0,1);
R1 = Resistor(200);
Rload = Resistor(1e3);
L1 = Inductor(Fs/2*100e-3);
p1 = Parallel(L1, Rload);
s1 =  Series(R1,p1); % create WDF tree as a ser. conn. of V1,C1, and R1
s2 = Series(V1, s1);

for i=1:N
    V1.E = input(i);
    b = WaveUp(s2); % get the waves up to the root
    WaveDown(s2,-b); 
    output(i) = Voltage(Rload);
end
%% 
plot((output))
%soundsc(output, Fs)