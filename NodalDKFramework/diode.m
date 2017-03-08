%  NodalDKFramework
%  Digital simulation of analog circuits
% 
% 

function obj = diode(name__, nodes__, value__)
    obj.nodes = zeros(2,2); % some components can be two-ports
    obj.name = zeros(1,8);  % the name must have the same length 
    l = min(8,length(name__));
    obj.nodes(1,:) = nodes__; % set the nodes 
    obj.name(1:l) = name__(1:l); % set the name
    obj.value = value__; % set the value
    obj.type = 'dio'; % 3char ID
    obj.model = '';
end


