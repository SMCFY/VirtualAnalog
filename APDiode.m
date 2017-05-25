classdef APDiode < audioPlugin
    
    properties
        gain = 1
        mix = 0.5
    end
    
    properties (Constant)
        % audioPluginInterface manages the number of input/output channels
        % and uses audioPluginParameter to generate plugin UI parameters.
        PluginInterface = audioPluginInterface(...
            audioPluginParameter('mix','DisplayName','Mix','Label','','Mapping',{'lin',0 1}),...
            audioPluginParameter('gain','DisplayName','Gain','Label','','Mapping',{'lin',0 5}));
    end
    
    properties (Access = private)
        pSR
        
        
        V1 % create a source with 0 (initial) voltage and 1 Ohm ser. res.
        R1 % create an 80Ohm resistor
        C1  % create the capacitance
        C2
        A1
        A2
        b = 0;
        Is = 2.52e-9;
        Vt = 45.3e-3;
        
        Rp
        maxIter = 10;
        dx = 1e-6;
        err =  1e-6;
        epsilon = 1e-9;
    end
    
    methods
        function obj = APDiode()
            obj.pSR = getSampleRate(obj);
            Fs = obj.pSR;
            obj.V1 = TerminatedVs(0, 2200);
            
            Ch = 0.47e-6; % the capacitance value in Farads
            
            obj.C1 = Capacitor(1/(2*Ch*Fs)); % create the capacitance
            
            Cl = 0.01e-6;
            
            obj.C2 = Capacitor(1/(2*Cl*Fs));
            
            obj.A1 = Series(obj.V1, obj.C1);
            obj.A2 = Parallel(obj.A1, obj.C2);
            obj.Rp = (obj.A2.PortRes*obj.C2.PortRes)/(obj.A2.PortRes+obj.C2.PortRes);
            
        end
        
        
        function reset(obj)
            obj.pSR = getSampleRate(obj);
            
        end
        function solveNL(obj, a)
            iter = 1;
            while (abs(obj.err) / abs(obj.b) > obj.epsilon )
                f = 2*obj.Is*sinh((a + obj.b)/(2*obj.Vt)) - (a - obj.b)/(2*obj.Rp);
                df = 2*obj.Is*sinh((a + (obj.b+obj.dx))/(2*obj.Vt)) - (a-(obj.b+obj.dx))/(2*obj.Rp);
                newB = obj.b - (obj.dx*f)/(df - f); 
                obj.b = newB;
                iter = iter + 1;
                if (iter > obj.maxIter)
                    break;
                end
            end
        end
        
        function out = process(obj, x)
            [numSamples,m] = size(x);
            output = zeros(size(x));
            input = obj.gain*sum(x,m)/m;
            for n = 1:numSamples % run each time sample until N
                obj.V1.E = input(n); % read the input signal for the voltage source
                a = WaveUp(obj.A2); 
                solveNL(obj, a);
                WaveDown(obj.A2, obj.b); % evaluate the wave leaving the diode (root element)
                output(n) = Voltage(obj.A2);
            end
            out = output*obj.mix + (1-obj.mix)*x;
        end
    end
end
