%----------------------Open circuit Class------------------------
classdef OpenCircuit < OnePort % a (linear) WDF open circuit
    methods
        function obj = OpenCircuit(PortRes) % constructor function
            obj.PortRes = PortRes; % port resistance (equal to el. res.)
        end
        function WU = WaveUp(obj) % get the up-going wave
            WU = obj.WD; % always zero for a linear WDF resistor
            obj.WU = WU;
        end
    end
end