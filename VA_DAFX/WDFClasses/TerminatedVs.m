%----------------------Terminated Voltage Source ------------------------
classdef TerminatedVs < OnePort % class for the WDF terminated voltage source (and ser. res.)
    properties
    E
    end
    methods
        function obj = TerminatedVs(E,PortRes) % constructor function
            obj.E = E;             % set the source voltage
            obj.PortRes = PortRes; % set the port resistance
        end
        function WU = WaveUp(obj) % evaluate the outgoing wave
            WU = obj.E; % from the def. of the WDF voltage source
            obj.WU = WU;
        end
    end
end