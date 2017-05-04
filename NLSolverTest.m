% Newton Raphson 
% cos x = x^3
% f(x) = cos x - x^3
% f'(x) = -sin x - 3x^2

x0 = 0.5; % initial guess
x = x0;
iter = 1;
b = [];
while (iter < 10)
    b(iter) = x;
    fx = cos(x) - x^3;
    fprime = -sin(x) - 3*x^2;
    newX = x - fx/fprime;
    x = newX;
    
    iter = iter + 1;
end

plot(1:10-1,b)
%%
% Implementation from WDF++
x0 = 0.5; % initial guess
x = x0;
iter = 1;

dx = 1e-6;
b2 = [];
maxIter = 10;
while (iter < maxIter)
    b2(iter) = x;
    f = cos(x) - x^3;
    df = cos(x+dx) - (x+dx)^3;
    newX = x - (dx*f)/(df - f);
    x = newX;
    
    iter = iter + 1;
end

plot(1:maxIter-1,b2)


%%  
% Newton Raphson from wiki 
% cos x = x^3
% f(x) = 2*Is*sinh(x/Vt)
% f'(x) = (2*Is*cosh(x/Vt))/Vt
x0 = 1; % initial guess
x = x0;
Is = 2.52e-9;
Vt = 45.3e-3;
iter = 1;
b = [];
while (iter < 100)
    b(iter) = x;
    fx = 2*Is*sinh(x/Vt);
    fprime = (2*Is*cosh(x/Vt))/Vt;
    newX = x - fx/fprime;
    x = newX;
    
    iter = iter + 1;
end

plot(1:100-1,b)

%% 
% Newton Raphson from wdf++
% cos x = x^3
% f(x) = 2*Is*sinh(x/Vt)
% f'(x) = (2*Is*cosh(x/Vt))/Vt
x0 = 0; % initial guess
b = x0;
Is = 2.52e-9;
Vt = 45.3e-3;
iter = 1;
a = 0.5;
Rp = 500;
dx = 1e-6;
b2 = [];
maxIter = 10000;
while (iter < maxIter)
    b2(iter) = b;
    f = 2*Is*sinh((a + b)/(2*Vt)) - (a-b)/(2*Rp) ;
    df = 2*Is*sinh((a + (b+dx))/2*Vt) - (a-(b+dx))/(2*Rp);
    %df = 2*Is*sinh((x+dx)/Vt);
    newB = b - (dx*f)/(df - f);
    b = newB;
    
    iter = iter + 1;
end

plot(1:maxIter-1,b2)

%%
% Implementation from WDF++
% Antiparallel diode equation added
x0 = 0.5; % initial guess
x = x0;
iter = 1;

dx = 1e-6;
b2 = [];
maxIter = 10;
%eq = 2*Is*sinh(Vdiode+b)/(2*Vt)-(Vdiode-b)/(Rp); Antiparallel equation
while (iter < maxIter)
    b2(iter) = x;
    f = 2*Is*sinh(Vdiode+b)/(2*Vt)-(Vdiode-b)/(Rp);
    df = 2*Is*sinh(Vdiode+b+dx)/(2*Vt)-(Vdiode-b+dx)/(Rp);
    newX = x - (dx*f)/(df - f);
    x = newX;
    
    iter = iter + 1;
end

plot(1:maxIter-1,b2)