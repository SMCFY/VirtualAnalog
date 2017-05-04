%----------------------V Class------------------------
classdef CurrentSourceIs < OnePort % class for the WDF voltage source (and ser. res.)
    properties
        Is % this is the source current
    end
    methods
        function obj = CurrentSourceIs(Is,PortRes) % constructor function
            obj.Is = Is; % set the current source
            obj.PortRes = PortRes; % set the port resistance
            obj.WD = 0; % initial value for the incoming wave
        end
        function WU = WaveUp(obj) % evaluate the outgoing wave
            WU = obj.WD + 2*obj.Is*obj.PortRes; % from the def. of the WDF current source
            obj.WU = WU;
        end
    end
end