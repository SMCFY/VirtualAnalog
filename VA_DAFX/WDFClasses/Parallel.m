%----------------------Parallel Class------------------------
classdef Parallel < Adaptor % the class for parallel 3-port adaptors
    properties
        WD = 0;% this is the down-going wave at the adapted port
        WU = 0;% this is the up-going wave at the adapted port
        G2
        G3
    end
    methods
        function obj = Parallel(KidLeft,KidRight) % constructor function
            obj.KidLeft = KidLeft; % connect the left 'child'
            obj.KidRight = KidRight; % connect the right 'child'
            obj.G2 = 1/KidLeft.PortRes; % G2 is the inverse port resistance from kidleft
            obj.G3 = 1/KidRight.PortRes; % G3 is the inverse port resistance from kidright
            
            % WDF++
            % left = l; right = r;
            % port->Rp = (left->R() * right->R())
            %         / (left->R() + right->R());
            obj.PortRes = (KidLeft.PortRes * KidRight.PortRes)/(KidLeft.PortRes + KidRight.PortRes); %obj.G2+obj.G3; % parallel adapt. port facing the root %
        end
        function WU = WaveUp(obj) % the up-going wave at the adapted port
            % A2 is the waveup(kidleft) and A3 is the waveup(kidright)
            % According to DAFx book: G2/(G2 + G3)A2 + G3/(G2 + G3)A3
            % WU = (obj.G2/(obj.G2 + obj.G3))*WaveUp(obj.KidLeft) + (obj.G3/(obj.G2+obj.G3)*WaveUp(obj.KidRight));% wave up
            
            % WDF++
            %register T lrG = left->G() + right->G();
            %port->b = ( left->G()/lrG) *  left->port->reflected() +
            %          (right->G()/lrG) * right->port->reflected();
            %return port->b;
            
            lrG = obj.G2 + obj.G3;
            WU = (obj.G2/lrG) * WaveUp(obj.KidLeft) + (obj.G3/lrG) * WaveUp(obj.KidRight);
            obj.WU = WU;
        end
        function setWD(obj,WaveFromParent) %  sets the down-going wave
            obj.WD = WaveFromParent; % set the down-going wave for the adaptor
            % set the waves to the 'children' according to the scattering rules
            % WDF++
            % register T lrG = left->G() + right->G();
            % register T lrW = (wave + left->port->b + right->port->b);
            % left->port->incident ( left->port->b - ( left->G()/lrG) * lrW);
            % right->port->incident (right->port->b - (right->G()/lrG) * lrW);
            % port->a = wave;
            
            lrG = obj.G2 + obj.G3;
            lrW = WaveFromParent + obj.KidLeft.WU + obj.KidRight.WU;
            
            left = obj.KidLeft.WU - (obj.G2/lrG) * lrW;
            right = obj.KidRight.WU - (obj.G3/lrG) * lrW;
            
            setWD(obj.KidLeft, left);
            setWD(obj.KidRight, right);
        end
        function adapt(obj)
            if isa(obj.KidLeft, 'ser')
                adapt(obj.KidLeft)
            end
            if isa(obj.KidRight, 'ser')
                adapt(obj.KidRight)
            end
            if isa(obj.KidLeft, 'Parallel')
                adapt(obj.KidLeft)
            end
            if isa(obj.KidRight, 'Parallel')
                adapt(obj.KidRight)
            end
            
            if isa(obj, 'ser')
                obj.PortRes = obj.KidLeft.PortRes+obj.KidRight.PortRes;
            end
            if isa(obj, 'Parallel')
                obj.PortRes = (obj.KidLeft.PortRes * obj.KidRight.PortRes)/(obj.KidLeft.PortRes + obj.KidRight.PortRes); % obj.G2+obj.G3; % parallel adapt. port facing the root
            end
        end
    end
end
