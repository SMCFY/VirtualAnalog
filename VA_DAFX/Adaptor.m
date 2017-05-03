%----------------------Adaptor Class------------------------
classdef Adaptor < WDF % the superclass for ser. and par. (3-port) adaptors
    properties
        KidLeft % a handle to the WDF element connected at the left port
        KidRight % a handle to the WDF element connected at the right port
    end
end