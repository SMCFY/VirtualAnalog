classdef diodeWDF < audioPlugin
    
    properties
        gain = 1
        mix = 0.5
        cap= 3.5e-5
        res = 80
    end
    
    properties (Constant)
        % audioPluginInterface manages the number of input/output channels
        % and uses audioPluginParameter to generate plugin UI parameters.
        PluginInterface = audioPluginInterface(...
            audioPluginParameter('cap','DisplayName','Capacitor Value','Label','','Mapping',{'lin',3.5e-8 0.001}),...
            audioPluginParameter('res','DisplayName','Resistor Value','Label','','Mapping',{'lin',0.1 1000}),...
            audioPluginParameter('mix','DisplayName','Mix','Label','','Mapping',{'lin',0 1}),...
            audioPluginParameter('gain','DisplayName','Gain','Label','','Mapping',{'lin',0 1}));
    end
    
    properties (Access = private)
        pSR
        
        Vdiode
        
        V1 % create a source with 0 (initial) voltage and 1 Ohm ser. res.
        R1 % create an 80Ohm resistor
        C1  % create the capacitance
        s1
    end
    
    methods
        function obj = diodeWDF()
            obj.pSR = getSampleRate(obj);
            
            %obj.gain = 30; % input signal gain parameter
            
            obj.V1 = VoltageSource(0,1); % create a source with 0 (initial) voltage and 1 Ohm ser. res.
            obj.R1 = Resistor(80); % create an 80Ohm resistor
            CapVal = 3.5e-5; % the capacitance value in Farads
            obj.C1 = Capacitor(1/(2*CapVal*obj.pSR)); % create the capacitance
            obj.s1 =  Series(obj.V1,Series(obj.C1,obj.R1)); % create WDF tree as a ser. conn. of V1,C1, and R1
            obj.Vdiode = 0; % initial value for the voltage over the diode
        end
        
        function set.res(obj, r)
            obj.res = r;
            obj.s1.KidRight.KidRight.PortRes = r;
            adapt(obj.s1);
        end
        function set.cap(obj, c)
            obj.cap = c;
            obj.s1.KidRight.KidLeft.PortRes = 1/(2*c*obj.pSR);
            adapt(obj.s1);
        end
        function reset(obj)
            obj.pSR = getSampleRate(obj);
            
            obj.Vdiode = 0; % initial value for the voltage over the diode
        end
        
        function out = process(obj, x)
            [numSamples,m] = size(x);
            output = zeros(size(x));
            input = obj.gain*sum(x,2)/2;
            for n = 1:numSamples % run each time sample until N
                obj.V1.E = input(n); % read the input signal for the voltage source
                WaveUp(obj.s1); % get the waves up to the root
                Rdiode = 125.56*exp(-0.036*obj.Vdiode); % the nonlinear resist. of the diode
                r = (Rdiode-obj.s1.PortRes)/(Rdiode+obj.s1.PortRes); % update scattering coeff.
                setWD(obj.s1, r*obj.s1.WU); % evaluate the wave leaving the diode (root element)
                obj.Vdiode = (obj.s1.WD+obj.s1.WU)/2; % update the diode voltage for next time sample
                output(n,:) = Voltage(obj.R1); % the output is the voltage over the resistor R1
            end
            %output = output/max(output);
            out = output*obj.mix + (1-obj.mix)*x;
        end
    end
end
