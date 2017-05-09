%----------------------Voltage Source Class------------------------
classdef VoltageSource < OnePort % class for the WDF voltage source (and ser. res.)
    properties
        E % this is the source voltage
    end
    methods
        function obj = VoltageSource(E,PortRes) % constructor function
            obj.E = E; % set the source voltage
            obj.PortRes = PortRes; % set the port resistance
            obj.WD = 0; % initial value for the incoming wave
        end
        function WU = WaveUp(obj) % evaluate the outgoing wave
            WU = 2*obj.E-obj.WD; % from the def. of the WDF voltage source
            obj.WU = WU;
        end
    end
end