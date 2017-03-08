classdef diodeModel < DKmodel
    
    properties(Constant)
        components_def = [inputPort('In',[1,0],0),...
            diode('Dio',[1,2],0),...
            outputPort('Out',[2,0])];
        
        components_count = struct('numResistors', 0,'numCapacitors', 0,...
            'numInputPorts', 1, 'numOutputPorts', 1,...
            'numNonlinearComponents',1, 'numPotmeters', 0,...
            'numNodes', 2, 'numOPAs', 0);
    end
    
    properties
        nonlin_model;
    end
    
    methods
        function obj = diodeModel(fs)
            obj.T = 1/fs;
            %obj.nonlin_model = obj.components_def(13).model;
            obj = buildModel(obj, obj.components_def,obj.components_count);
        end
        
        function obj = load_input(obj,in)
            obj.U(1) = in; % loads the input signal sample given by in into inputs vector U
        end
        
        function [i, J] = nonlinearity(obj,v)
            [i,J] = obj.nonlin_model(v);
            %[i, J] = ecc83_tube_model(v);
        end
        
    end
end