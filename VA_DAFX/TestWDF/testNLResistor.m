% test NL resistor
NLR = NLResistor(569.2);
a = -1:0.01:1;
b = zeros(size(a));
for n = 1:length(a)
    setWD(NLR, a(n));
    b(n) = NLR.WD;
end
plot(a, b)

