%----------------------TerminatedB------------------------
classdef TerminatedB < OnePort % class for the WDF voltage source (and ser. res.)
    methods
        function obj = TerminatedB(E,PortRes) % constructor function
            obj.E = E;              % set the source voltage
            obj.PortRes = PortRes; % set the port resistance
            obj.WD = 0; % initial value for the incoming wave
        end;
        function WU = WaveUp(obj) % evaluate the outgoing wave
            WU = obj.E; % from the def. of the WDF voltage source
            obj.WU = WU;
        end;
    end
end