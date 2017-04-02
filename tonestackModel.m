classdef tonestackModel < DKmodel
    
    properties(Constant)
        components_def = [resistor('R0',[1,2],38000),...
            	resistor('R1',[2,5],1000000),...
            	resistor('R2',[3,4],250000),...
            	resistor('R3',[4,6],250000),...
            	resistor('R4',[6,0],10000),...
                capacitor('C1',[2,3],100e-9),...
                capacitor('C2',[5,4],100e-9),...
            	capacitor('C3',[5,6],47e-9),... 
                inputPort('In',[0,1],0),...
            	outputPort('Out',[4,0])];    
            	
            components_count = struct('numResistors', 5,'numCapacitors', 3,...
                'numInputPorts', 1, 'numOutputPorts', 1,...
                'numNonlinearComponents',0, 'numPotmeters', 0,...
                'numNodes', 6, 'numOPAs', 0);
    end
    
    properties
        nonlin_model;
    end
    
    methods
        function obj = tonestackModel(fs)
           obj.T = 1/fs;
           %obj.maxIter = 8;
           %obj.nonlin_model = obj.components_def(13).model;
           obj = buildModel(obj, obj.components_def,obj.components_count);
        end
 
        function obj = load_input(obj,in)        
               obj.U(1) = in; % loads the input signal sample given by in into inputs vector U
           end
                  
        function [i, J] = nonlinearity(obj,v)
            %[i,J] = obj.nonlin_model(v);
            [i, J] = ecc83_tube_model(v);
        end     
  
    end
end