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
            
            left = obj.KidLeft.WU-(obj.KidLeft.PortRes/...
            obj.PortRes)*(WaveFromParent+obj.KidLeft.WU+obj.KidRight.WU);
            
            set(obj.KidLeft,'WD',left); 
            
            right = obj.KidRight.WU-(obj.KidRight.PortRes/...
            obj.PortRes)*(WaveFromParent+obj.KidLeft.WU+obj.KidRight.WU);
            
            set(obj.KidRight,'WD',right);
        end;
    end 
end
