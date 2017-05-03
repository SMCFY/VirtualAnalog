%----------------------OnePort Class------------------------
classdef OnePort < WDF % superclass for all WDF one-port elements
    properties
        WD = 0;  % the incoming wave to the one-port element
        WU = 0;  % the out-going wave from the one-port element
    end
        methods 
            function setWD(obj,val) % this function sets the out-going wave
            obj.WD = val;
                if or(strcmp(class(obj),'C'),strcmp(class(obj),'L')) % if react.
                    obj.State = val; % update internal state
                end
            end
        end 
end