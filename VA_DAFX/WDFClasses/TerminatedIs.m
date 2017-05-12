%----------------------V Class------------------------
classdef TerminatedIs < OnePort % class for the WDF voltage source (and ser. res.)
    properties
        Is % this is the source current
    end
    methods
        function obj = TerminatedIs(Is,PortRes) % constructor function
            obj.Is = Is; % set the current source
            obj.PortRes = PortRes; % set the port resistance
            obj.WD = 0; % initial value for the incoming wave
        end
        function WU = WaveUp(obj) % evaluate the outgoing wave
            WU = obj.Is*obj.PortRes; % from the def. of the WDF terminated current source
            obj.WU = WU;
        end
    end
end