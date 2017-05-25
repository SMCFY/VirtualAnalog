%----------------------OnePort Class------------------------
classdef OnePort < WDF % superclass for all WDF one-port elements
    properties
        WD = 0;  % the incoming wave to the one-port element
        WU = 0;  % the out-going wave from the one-port element
    end
    methods
        function WaveDown(obj,val) % this function sets the out-going wave
            obj.WD = val;
            if or(isa(obj,'Capacitor'),isa(obj,'Inductor')) % if react.
                obj.State = val; % update internal state
            end
        end
    end
end