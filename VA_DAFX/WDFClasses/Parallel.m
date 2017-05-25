%----------------------Parallel Class------------------------
classdef Parallel < Adaptor % the class for parallel 3-port adaptors
    properties
        WD = 0;% this is the down-going wave at the adapted port
        WU = 0;% this is the up-going wave at the adapted port
        pb2 = 0; 
        a1 = 0;
        a2 = 0;
        gamma = 0;
    end
    methods
        function obj = Parallel(KidLeft,KidRight) % constructor function
            obj.KidLeft = KidLeft; % connect the left 'child'
            obj.KidRight = KidRight; % connect the right 'child'
            % BCT
            R1 = KidLeft.PortRes;
            R2 = KidRight.PortRes; 
            
            R = (R1 * R2)/(R1 + R2);
            obj.PortRes = R;
            obj.gamma = R/KidLeft.PortRes;
        end
        function WU = WaveUp(obj) % the up-going wave at the adapted port
            % Scattering method from BCT
            obj.a1 = WaveUp(obj.KidLeft);
            obj.a2 = WaveUp(obj.KidRight);
            obj.pb2 = obj.gamma * (obj.a1 - obj.a2);
            WU = obj.pb2 + obj.a2;
            obj.WU = WU;
        end
        function WaveDown(obj,WaveFromParent) %  sets the down-going wave
            obj.WD = WaveFromParent; % set the down-going wave for the adaptor
           
            % Scattering method from BCT   
            b3 = obj.pb2 + obj.a2; 
            a3 = WaveFromParent;

            left = b3 - obj.a1 + a3;
            right = obj.pb2 + a3;

            WaveDown(obj.KidLeft, left);
            WaveDown(obj.KidRight, right);
        end
    end
end
