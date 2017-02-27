%  NodalDKFramework
%  Digital simulation of analog circuits
% 
%  Jaromir Macak
%  jarda.macak@seznam.cz
% 
%  14.1.2017
% 
%  Copyright 2017, All Rights Reserved.
%  
%  This software may be licensed under the terms of the
%  GNU Public License v3 (LICENSE-gpl3.txt) or the custom license
% (LICENSE.txt) located at the root of the source distribution.
%  These files may also be found in the public source
%  code repository located at:
%         https://github.com/jardamacak/NodalDKFramework

function obj = resistor(name__, nodes__, value__)
    obj.nodes = zeros(2,2); % some components can be two-ports
    obj.name = zeros(1,8);  % the name must have the same length 
    l = min(8,length(name__));
    obj.nodes(1,:) = nodes__; % set the nodes 
    obj.name(1:l) = name__(1:l); % set the name
    obj.value = value__; % set the value
    obj.type = 'res'; % 3char ID
    obj.model = '';
end


