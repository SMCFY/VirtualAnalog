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
        function setWD(obj,WaveFromParent) %  sets the down-going wave
            obj.WD = WaveFromParent; % set the down-going wave for the adaptor
            % set the waves to the 'children' according to the scattering rules
            
            left = obj.KidLeft.WU-(obj.KidLeft.PortRes/...
                obj.PortRes)*(WaveFromParent+obj.KidLeft.WU+obj.KidRight.WU);
            
            right = obj.KidRight.WU-(obj.KidRight.PortRes/...
                obj.PortRes)*(WaveFromParent+obj.KidLeft.WU+obj.KidRight.WU);
            
            setWD(obj.KidLeft,left);
            setWD(obj.KidRight,right);
        end
        function updatePortRes(obj, PortRes, side)
            if side == 'l'
                updatePortRes(obj.KidLeft, PortRes); 
            end
            if side == 'r'
                obj.KidRight.updatePortRes(PortRes); 
            end
            %obj = ser(obj.KidLeft,obj.KidRight);
        end
        function adapt(obj)
            if isa(obj.KidLeft, 'Series')
                adapt(obj.KidLeft)    
            end
            if isa(obj.KidRight, 'Series')
                adapt(obj.KidRight)
            end
            if isa(obj.KidLeft, 'Parallel')
                adapt(obj.KidLeft)
            end
            if isa(obj.KidRight, 'Parallel')
                adapt(obj.KidRight)
            end
            
            if isa(obj, 'Series')
                obj.PortRes = obj.KidLeft.PortRes+obj.KidRight.PortRes;
            end
            if isa(obj, 'Parallel')
                obj.PortRes = (obj.KidLeft.PortRes * obj.KidRight.PortRes)/(obj.KidLeft.PortRes + obj.KidRight.PortRes); % obj.G2+obj.G3; % parallel adapt. port facing the root
            end
        end
    end
end
