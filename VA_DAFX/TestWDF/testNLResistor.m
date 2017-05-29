% test NL resistor
NLR = NLResistor(569.2);
a = -1:0.5:1;
b = zeros(size(a));
for n = 1:length(a)
    WD = WaveDown(NLR, a(n));
    b(n) = WD;
end


plot(a, b,'LineWidth',2)
xlabel('a', 'FontSize', 14); ylabel('b', 'FontSize', 14)
title('Nonlinear Resistor', 'FontSize', 18)
