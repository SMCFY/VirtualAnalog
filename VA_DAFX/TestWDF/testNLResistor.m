% test NL resistor
NLR = NLResistor(569.2);
a = -1:0.2:1;
b = zeros(size(a));
for n = 1:length(a)
    WD = setWD(NLR, a(n));
    b(n) = WD;
end


plot(a, b,'LineWidth',2)
xlabel('a'); ylabel('b')
title('Nonlinear Resistor', 'FontSize', 18)
