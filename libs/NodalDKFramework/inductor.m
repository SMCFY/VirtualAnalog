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

function obj = inductor(name__, nodes__, value__)
obj.nodes = zeros(2,2);
    obj.name = zeros(1,8);
    l = min(8,length(name__));
    obj.nodes(1,:) = nodes__;
    obj.name(1:l) = name__(1:l);
    obj.value = value__;
    obj.type = 'ind';
    obj.model = '';
end

