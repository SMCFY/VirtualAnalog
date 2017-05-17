%----------------------WDF Class------------------------
classdef WDF < handle % the WDF element superclass
    properties
        PortRes % the WDF port resistance
    end
    methods
        function Volts = Voltage(obj)  % the voltage (V) over a WDF element
            Volts = (obj.WU+obj.WD)/2; % as defined in the WDF literature
        end
        function state = getState(obj)  % the state of C or L
            if isa(obj, 'Capacitor')
                state = obj.State; % as defined in the WDF literature
            elseif isa(obj, 'Inductor')
                state = -obj.State; % as defined in the WDF literature            
            else
                state = 0;
            end
        end
    end
end