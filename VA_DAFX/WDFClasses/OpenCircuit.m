%----------------------Open circuit Class------------------------
classdef OpenCircuit < OnePort % a WDF open circuit
    methods
        function obj = OpenCircuit(PortRes) % constructor function
            obj.PortRes = PortRes; % port resistance 
        end
        function WU = WaveUp(obj) % get the up-going wave
            WU = obj.WD; 
            obj.WU = WU;
        end
    end
end