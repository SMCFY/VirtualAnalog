classdef PhasorRT < audioPlugin
    
    properties
        Freq1 = 1
        Freq2 = 1
        Freq3 = 1
        Freq4 = 1
        
        R1 = .1
        R2 = .1
        R3 = .1
        R4 = .1
        
        Mix = 0.5
    end
    
    properties (Dependent)
    end
    
    properties
        
    end
    
    properties (Constant)
        % audioPluginInterface manages the number of input/output channels
        % and uses audioPluginParameter to generate plugin UI parameters.
        PluginInterface = audioPluginInterface(...
            audioPluginParameter('Freq1','DisplayName','Freq1','Label','','Mapping',{'lin',0.1 10}),...
            audioPluginParameter('Freq2','DisplayName','Freq2','Label','','Mapping',{'lin',0.1 10}),...
            audioPluginParameter('Freq3','DisplayName','Freq3','Label','','Mapping',{'lin',0.1 10}),...
            audioPluginParameter('Freq4','DisplayName','Freq4','Label','','Mapping',{'lin',0.1 10}),...
            audioPluginParameter('R1','DisplayName','R1','Label','','Mapping',{'lin',0 1}),...
            audioPluginParameter('R2','DisplayName','R2','Label','','Mapping',{'lin',0 1}),...
            audioPluginParameter('R3','DisplayName','R3','Label','','Mapping',{'lin',0 1}),...
            audioPluginParameter('R4','DisplayName','R4','Label','','Mapping',{'lin',0 1}),...
            audioPluginParameter('Mix','DisplayName','Dry/Wet','Label','%','Mapping',{'lin',0 1}));
    end
    
    properties (Access = private)
        pSR
        
        AP1 = [0, 0, 0];
        AP2 = [0, 0, 0];
        AP3 = [0, 0, 0];
        AP4 = [0, 0, 0];
        
        xn1 = 0;
        xn2 = 0;
        
        theta1
        theta2
        theta3 
        theta4
        
    end
    
    methods
        function obj = PhasorRT()
            obj.pSR = getSampleRate(obj);
            obj.theta1 = 0;
            obj.theta2 = 0;
            obj.theta3 = 0;
            obj.theta4 = 0;
            %             obj.theta1 = obj.Freq1*2*pi/obj.pSR;
            %             obj.theta2 = obj.Freq2*2*pi/obj.pSR;
            %
            %             obj.theta3 = obj.Freq3*2*pi/obj.pSR;
            %
            %             obj.theta4 = obj.Freq4*2*pi/obj.pSR;
            
        end
        
        
        
        function reset(obj)
            obj.pSR = getSampleRate(obj);
            
        end
        
        function out = process(obj, x)
            [m,n]=size(x);
            y = zeros(size(x));
            delta1 = (obj.Freq1*2*pi/obj.pSR);
            delta2 = (obj.Freq2*2*pi/obj.pSR);
            delta3 = (obj.Freq3*2*pi/obj.pSR);
            delta4 = (obj.Freq4*2*pi/obj.pSR);
            
            a21 = obj.R1^2;
            a22 = obj.R2^2;
            a23 = obj.R3^2;
            a24 = obj.R4^2;
            
            for i=1:m
                obj.theta1 = obj.theta1 + delta1;
                if obj.theta1 > 2*pi
                    obj.theta1 = obj.theta1 - 2*pi;
                end
                
                obj.theta2 = obj.theta2 + delta2;
                if obj.theta2 > 2*pi
                    obj.theta2 = obj.theta2 - 2*pi;
                end
                
                obj.theta3 = obj.theta3 + delta3;
                if obj.theta3 > 2*pi
                    obj.theta3 = obj.theta3 - 2*pi;
                end
                
                obj.theta4 = obj.theta4 + delta4;
                if obj.theta4 > 2*pi
                    obj.theta4 = obj.theta4 - 2*pi;
                end
                
                a11 = -2*obj.R1*cos(obj.theta1);
                a12 = -2*obj.R2*cos(obj.theta2);
                a13 = -2*obj.R3*cos(obj.theta3);                
                a14 = -2*obj.R4*cos(obj.theta4);
                
                % first allpas
                obj.AP1(1) = a21 * x(i,1) + a11 * obj.xn1 + obj.xn2 - a11 * obj.AP1(2) - a21 * obj.AP1(3);
                
                % second allpas
                obj.AP2(1) = a22 * obj.AP1(1)+ a12 * obj.AP1(2) + obj.AP1(3) - a12 * obj.AP2(2) - a22 * obj.AP2(3);
                
                % third allpass
                obj.AP3(1) = a23 * obj.AP2(1)+ a13 * obj.AP2(2) + obj.AP2(3) - a13 * obj.AP3(2) - a23 * obj.AP3(3);
                
                % fourth allpass
                obj.AP4(1) = a24 * obj.AP3(1)+ a14 * obj.AP3(2) + obj.AP3(3) - a14 * obj.AP4(2) - a24 * obj.AP4(3);
                
                % signal
                obj.xn2 = obj.xn1;
                obj.xn1 = x(i,1);
                
                % first allpass
                obj.AP1(3) = obj.AP1(2);
                obj.AP1(2) = obj.AP1(1);
                
                % second allpass
                obj.AP2(3) = obj.AP2(2);
                obj.AP2(2) = obj.AP2(1);
                
                % third allpass
                obj.AP3(3) = obj.AP3(2);
                obj.AP3(2) = obj.AP3(1);
                
                % fourth allpass
                obj.AP4(3) = obj.AP4(2);
                obj.AP4(2) = obj.AP4(1);
                
                y(i,:) = obj.AP4(1);
            end
            wet = obj.Mix;
            out = (1-wet)*x + wet*y;
        end
    end
end
