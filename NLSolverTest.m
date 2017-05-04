% Newton Raphson 
% cos x = x^3
% f(x) = cos x - x^3
% f'(x) = -sin x - 3x^2

x0 = 0.5; % initial guess
x = x0;
iter = 1;
b = [];
while (iter < 100)
    b(iter) = x;
    fx = cos(x) - x^3;
    fprime = -sin(x) - 3*x^2;
    newX = x - fx/fprime;
    x = newX;
    
    iter = iter + 1;
end

scatter(1:100-1,b)

%%  
% Newton Raphson from wdf++
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
% Newton Raphson 
% cos x = x^3
% f(x) = 2*Is*sinh(x/Vt)
% f'(x) = (2*Is*cosh(x/Vt))/Vt
x0 = 1; % initial guess
b = x0;
Is = 2.52e-9;
Vt = 45.3e-3;
iter = 1;
a = 1.5;
Rp = 5000;
dx = 1e-6;
b2 = [];
maxIter = 10000;
while (iter < maxIter)
    b2(iter) = b;
    f = 2*Is*sinh((a - b)/(2*Vt)) - (a-b)/(2*Rp) ;
    df = 2*Is*sinh((a - (b+dx))/2*Vt) - (a-(b+dx))/(2*Rp);
    %df = 2*Is*sinh((x+dx)/Vt);
    newB = b - (dx*f)/(df - f);
    b = newB;
    
    iter = iter + 1;
end

plot(1:maxIter-1,b2)

