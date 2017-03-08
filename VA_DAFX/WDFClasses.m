% WDFclasses.m
% Authors: Välimäki, Bilbao, Smith, Abel, Pakarinen, Berners
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

%----------------------WDF Class------------------------
classdef WDF < hgsetget % the WDF element superclass
    properties 
        PortRes % the WDF port resistance
    end
    methods
            function Volts = Voltage(obj)  % the voltage (V) over a WDF element
                Volts = (obj.WU+obj.WD)/2; % as defined in the WDF literature
            end
    end;
end
%----------------------Adaptor Class------------------------
classdef Adaptor < WDF % the superclass for ser. and par. (3-port) adaptors
    properties
        KidLeft % a handle to the WDF element connected at the left port
        KidRight % a handle to the WDF element connected at the right port
    end;
end
%----------------------Ser Class------------------------
classdef ser < Adaptor % the class for series 3-port adaptors
    properties
        WD % this is the down-going wave at the adapted port
        WU % this is the up-going wave at the adapted port
    end;
    methods 
        function obj = ser(KidLeft,KidRight) % constructor function
            obj.KidLeft = KidLeft; % connect the left 'child'
            obj.KidRight = KidRight; % connect the right 'child'
            obj.PortRes = KidLeft.PortRes+KidRight.PortRes; % adapt. port
        end;
        function WU = WaveUp(obj) % the up-going wave at the adapted port
            WU = -(WaveUp(obj.KidLeft)+WaveUp(obj.KidRight)); % wave up
            obj.WU = WU; 
        end;
        function set.WD(obj,WaveFromParent) %  sets the down-going wave
            obj.WD = WaveFromParent; % set the down-going wave for the adaptor
            % set the waves to the 'children' according to the scattering rules
            set(obj.KidLeft,'WD',obj.KidLeft.WU-(obj.KidLeft.PortRes/...
            obj.PortRes)*(WaveFromParent+obj.KidLeft.WU+obj.KidRight.WU)); 
            set(obj.KidRight,'WD',obj.KidRight.WU-(obj.KidRight.PortRes/...
            obj.PortRes)*(WaveFromParent+obj.KidLeft.WU+obj.KidRight.WU));
        end;
    end 
end
%----------------------OnePort Class------------------------
classdef OnePort < WDF % superclass for all WDF one-port elements
    properties
        WD % the incoming wave to the one-port element
        WU % the out-going wave from the one-port element
    end;
        methods 
            function obj = set.WD(obj,val) % this function sets the out-going wave
            obj.WD = val;
                if or(strcmp(class(obj),'C'),strcmp(class(obj),'L')) % if react.
                    obj.State = val; % update internal state
                end;
            end;
        end 
end
%----------------------R Class------------------------
classdef R < OnePort % a (linear) WDF resistor
        methods 
            function obj = R(PortRes) % constructor function
                obj.PortRes = PortRes; % port resistance (equal to el. res.)
            end;
            function WU = WaveUp(obj) % get the up-going wave
                WU = 0; % always zero for a linear WDF resistor
                obj.WU = WU;
            end;
        end 
end
%----------------------C Class------------------------
classdef C < OnePort
    properties
        State % this is the one-sample internal memory of the WDF capacitor
    end;
        methods 
            function obj = C(PortRes) % constructor function
                obj.PortRes = PortRes; % set the port resistance
                obj.State = 0; % initialization of the internal memory
            end;
            function WU = WaveUp(obj) % get the up-going wave
                WU = obj.State; % in practice, this implements the unit delay
                obj.WU = WU;
            end;
        end 
end
%----------------------V Class------------------------
classdef V < OnePort % class for the WDF voltage source (and ser. res.)
    properties
        E % this is the source voltage
    end
        methods 
            function obj = V(E,PortRes) % constructor function
                obj.E = E; % set the source voltage
                obj.PortRes = PortRes; % set the port resistance
                obj.WD = 0; % initial value for the incoming wave
            end;
            function WU = WaveUp(obj) % evaluate the outgoing wave
                WU = 2*obj.E-obj.WD; % from the def. of the WDF voltage source
                obj.WU = WU;
            end;
        end 
end