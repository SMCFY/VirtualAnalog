%----------------------Non linear Resistor Class------------------------
classdef NLResistor < OnePort % a (nonlinear) WDF resistor
    properties
        G1 = -0.0005; % -500uS
        G2 = -0.0008; % -800uS
        v0 = 1;       % 1V
        %R = 569.2;    % Resistance, can maybe work as PortRes;
        g1 = 0; 
        g2 = 0; 
        a0 = 0;
        
    end
    methods
        function obj = NLResistor(PortRes) % constructor function
            obj.PortRes = PortRes; % port resistance (equal to el. res.)
            R = PortRes;
            obj.g1 = (1-obj.G1*R)/(1+obj.G1*R);
            obj.g2 = (1-obj.G2*R)/(1+obj.G2*R);
            obj.a0 = obj.v0 * (1+obj.G2*R);
        end
        function WU = WaveUp(obj) % get the up-going wave
            
            WU = 0; % always zero for a linear WDF resistor
            obj.WU = WU;
        end
        function WD = setWD(obj, a) % get the down-going wave
            
            WD = obj.g1*a+1/2*(obj.g2-obj.g1)*(abs(a + obj.a0) - abs(a - obj.a0)); % eq. 17 DIGITAL SIMULATION OF NONLINEAR CIRCUITS BY WAVE DIGITAL FILTER PRINCIPLES, Meerkötter and Scholz
            obj.WD = WD;
        end
    end
end