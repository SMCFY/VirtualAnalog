%----------------------C Class------------------------
classdef L < OnePort
    properties
        State % this is the one-sample internal memory of the WDF capacitor
    end;
        methods 
            function obj = L(PortRes) % constructor function
                obj.PortRes = PortRes; % set the port resistance
                obj.State = 0; % initialization of the internal memory
            end;
            function WU = WaveUp(obj) % get the up-going wave
                WU = -obj.State; % in practice, this implements the unit delay
                obj.WU = WU;
            end;
        end 
end