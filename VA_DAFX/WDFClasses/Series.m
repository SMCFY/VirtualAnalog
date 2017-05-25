%----------------------Series Class------------------------
classdef Series < Adaptor % the class for series 3-port adaptors
    properties
        WD = 0; % this is the down-going wave at the adapted port
        WU = 0; % this is the up-going wave at the adapted port
    end
    methods
        function obj = Series(KidLeft,KidRight) % constructor function
            obj.KidLeft = KidLeft; % connect the left 'child'
            obj.KidRight = KidRight; % connect the right 'child'
            obj.PortRes = KidLeft.PortRes+KidRight.PortRes; % adapt. port
        end
        function WU = WaveUp(obj) % the up-going wave at the adapted port
            WU = -(WaveUp(obj.KidLeft)+WaveUp(obj.KidRight)); % wave up
            obj.WU = WU;
        end
        function WaveDown(obj,WaveFromParent) %  sets the down-going wave
            obj.WD = WaveFromParent; % set the down-going wave for the adaptor
            % set the waves to the 'children' according to the scattering rules
            
            left = obj.KidLeft.WU-(obj.KidLeft.PortRes/...
                obj.PortRes)*(WaveFromParent+obj.KidLeft.WU+obj.KidRight.WU);
            
            right = obj.KidRight.WU-(obj.KidRight.PortRes/...
                obj.PortRes)*(WaveFromParent+obj.KidLeft.WU+obj.KidRight.WU);
            
            WaveDown(obj.KidLeft,left);
            WaveDown(obj.KidRight,right);
        end
    end
end
