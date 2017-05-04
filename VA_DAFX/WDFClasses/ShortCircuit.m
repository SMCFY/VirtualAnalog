%----------------------ShortCircuit Class------------------------
classdef ShortCircuit < OnePort % class for the WDF voltage source (and ser. res.)
    methods
        function obj = ShortCircuit(PortRes) % constructor function
            obj.PortRes = PortRes; % set the port resistance
        end;
        function WU = WaveUp(obj) % evaluate the outgoing wave
            WU = -obj.WD; % from the def. of the WDF voltage source
            obj.WU = WU;
        end;
    end
end