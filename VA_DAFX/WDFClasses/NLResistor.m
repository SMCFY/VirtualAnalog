%----------------------Non linear Resistor Class------------------------
classdef NLResistor < OnePort % a (nonlinear) WDF resistor
    methods
        function obj = NLResistor(PortRes) % constructor function
            obj.PortRes = PortRes; % port resistance (equal to el. res.)
        end
        function WU = WaveUp(obj) % get the up-going wave
            WU = 0; % always zero for a linear WDF resistor
            obj.WU = WU;
        end
    end
end