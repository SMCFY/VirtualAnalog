function [ b ] = ChuaResistor( a )
      G1 = -0.0005; % -500uS
      G2 = -0.0008; % -800uS
      v0 = 1;       % 1V
      R = 569.2;    % Resistance, can maybe work as PortRes;
      g1 = (1-G1*R)/(1+G1*R);
      g2 = (1-G2*R)/(1+G2*R);
      a0 = v0 * (1+G2*R);
    
      b = g1*a+1/2*(g2-g1)*(abs(a + a0) - abs(a - a0)); % eq. 17 DIGITAL SIMULATION OF NONLINEAR CIRCUITS BY WAVE DIGITAL FILTER PRINCIPLES, Meerkötter and Scholz
end

