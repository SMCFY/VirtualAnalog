classdef diodeModel < DKmodel
    
    properties(Constant)
        components_def = [inputPort('In',[1,0],0),...
            diode('D1',[2,3],0),...
            resistor('R1',[1,2],1000),...
            resistor('R2',[3,4],10000),...
            capacitor('C1',[4,5],20e-9),...
            outputPort('Out',[5,0])];
        
        components_count = struct('numResistors', 2,'numCapacitors', 1,...
            'numInputPorts', 1, 'numOutputPorts', 1,...
            'numNonlinearComponents',1, 'numPotmeters', 0,...
            'numNodes', 5, 'numOPAs', 0);
    end
    
    properties
        nonlin_model;
    end
    
    methods
        function obj = diodeModel(fs)
            obj.T = 1/fs;
            obj.nonlin_model = obj.components_def(2).model;
            obj = buildModel(obj, obj.components_def,obj.components_count);
        end
        
        function obj = load_input(obj,in)
            obj.U(1) = in; % loads the input signal sample given by in into inputs vector U
        end
        
        function [i, J] = nonlinearity(obj,v)
            %[i,J] = obj.nonlin_model(v);
            [i, J] = diode_test_model(v);
        end
        
    end
end