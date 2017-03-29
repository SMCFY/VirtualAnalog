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

classdef DKmodel
       properties 
       A,B,C,D,E,F,G,H,K % DK method matrices
       x % state variable
       U % inputs vector
       v % unknown voltages
       T % sampling period
       eps = 0.05; % eps for newton raphson method
       maxIter = 10;  % max iterations for newton raphson method   
       end 
       
       methods
           
           % processing function solving the system for input signal in
           function [out, obj] = process(obj,in)     
               out = zeros(size(in));% allocate output signal buffer
               for channel = 1:size(in,2) % channels loop
                   for sample = 1:size(in,1) % samples loop
                       % load inputs from the model
                       s = in(sample,channel); 
                       obj = load_input(obj,s); 
                       if(isempty(obj.K))
                           if(isempty(obj.x))
                               outsample = (obj.E*obj.U);
                           else
                                outsample = (obj.D*obj.x(:,channel)  + obj.E*obj.U);
                                obj.x(:,channel) = obj.A*obj.x(:,channel) + obj.B*obj.U;
                           end
                       else
                           if(isempty(obj.x))
                               % calculata p vectpr
                               p = obj.H*obj.U;
                               % find the currents
                               [obj.v, I] = solve_nonlinear_func(obj,p, obj.K);  
                               % output sample
                               outsample = (obj.E*obj.U + obj.F*I);
                           else
                               % calculata p vectpr
                               p = obj.G*obj.x(:,channel) + obj.H*obj.U;
                               % find the currents
                               [obj.v, I] = solve_nonlinear_func(obj,p, obj.K);  
                               % output sample
                               outsample = (obj.D*obj.x(:,channel)  + obj.E*obj.U + obj.F*I);
                               % update model state
                               obj.x(:,channel) = obj.A*obj.x(:,channel) + obj.B*obj.U + obj.C*I;
                           end
                       end
                       [out(sample,channel), obj] = store_output(obj,outsample);
                   end
               end
           end  
           
           % loads the input signal sample given by in into inputs vector U
           function obj = load_input(obj,in) 
               % this method should be overriden in subclass
               obj.U(1,1) = in;
           end
           
           % loads the input signal sample given by in into inputs vector U
           function [out, obj] = store_output(obj,output)      
               % this method should be overriden in subclass
               out = output(1);
           end
           
           % nonlinear function of the system
           function [i, J] = nonlinearity(obj,v)
               % this method must be overriden in subclass for nonlinear
               % system
               i = v;
               J = eye(size(v));
           end
          
           % build nonlinear state space model using incidence matrixes (Nodal DK method)
           function obj = makeDKMatrices(obj,Nr,Gr, Nx, Gx, Nn, Nu, No,Z, Nopai, Nopao)
               % source: Martin Holters and Udo Zölzer, Physical Modelling of a Wah-wah Effect Pedal as a Case Study for Application of the Nodal DK Method to Circuits with Variable Parts
               % source: Jaromir Macak, REAL-TIME DIGITAL SIMULATION OF GUITAR AMPLIFIERS AS AUDIO EFFECTS
                % extend indeces matrixes by the number of ideal voltage sources
                numVoltageSources = size(Nu,1); % number of rows in voltage sources matrix Nu
                numRealNodes = size(Nu,2); % number of columns in any of Nr, Nx, Nn, Nu, No...
                % build conductance matrix with basic pasive elements R, L, C 
                if(isempty(Nx)) % no capacitors or inductors in the circuit
                    S = [(Nr'*Gr*Nr) Nu';...
                    Nu zeros(numVoltageSources)];
                else
                    S = [(Nr'*Gr*Nr + Nx'*Gx*Nx) Nu';...
                    Nu zeros(numVoltageSources)];
                end
                % add OPAs to the conductance matrix
                numOpas = size(Nopai,1);
                if(numOpas > 0) % are there any
                    amp = 10000000; % TODO: add configurable OPA amplification
                    % extend incidence matrix Nopax by number of voltage
                    % sources Nu
                    Nopao = [Nopao zeros(size(Nopao ,1),numVoltageSources)];
                    Nopai = [Nopai zeros(size(Nopai ,1),numVoltageSources)];
                    % updated conductance matrix by adding linear OPA model
                    S = [S Nopao'; Nopao+amp.*Nopai zeros(size(Nopao ,1))];
                end      
                % extend incidence matrixes by number of voltage sources Nu  and OPAs      
                Nrp = [Nr zeros(size(Nr,1),numVoltageSources+numOpas)]; % not needed, but keep it
                Nxp = [Nx zeros(size(Nx,1),numVoltageSources+numOpas)];
                Nnp = [Nn zeros(size(Nn,1),numVoltageSources+numOpas)];
                Nop = [No zeros(size(No,1),numVoltageSources+numOpas)];
                Nup = [Nu zeros(size(Nu,1),numVoltageSources)];  % not needed, but keep it
                % resolve voltage sources matrix Nup to proper format under new variable Nup2  
                Nup2 = [zeros(numRealNodes,numVoltageSources); eye(numVoltageSources); zeros(numOpas,numVoltageSources)];

                % inverse the conductance matrix
                Si = inv(S);
                
                % nonlinear state space model matrixes
                if(isempty(Nx)) % no memory componets L or C
                    obj.A = [];
                    obj.B = [];
                    obj.C = [];
                    obj.D = [];
                    obj.G = [];
                else
                    obj.A = 2*Z*Gx*Nxp*Si*Nxp' - Z;
                    obj.B = 2*Z*Gx*Nxp*Si*Nup2;
                    obj.C = 2*Z*Gx*Nxp*Si*Nnp';
                    obj.D = Nop*Si*Nxp';
                    obj.G = Nnp*Si*Nxp';      
                end   
                if(isempty(Nn)) % linear model
                    obj.F = [];
                    obj.K = [];
                else
                    obj.F = Nop*Si*Nnp';
                    obj.K = Nnp*Si*Nnp';
                end
                obj.E = Nop*Si*Nup2;
                obj.H = Nnp*Si*Nup2;
           end
              
           function [v, I] = solve_nonlinear_func(obj, p, K)
             iter = obj.maxIter;
             v0 = obj.v;
             v = v0 + 2*obj.eps;
             while(iter > 0 || any(abs(v-v0) > obj.eps))
                 [it, Jt] = nonlinearity(obj,v);
                 e = p + K*it - v;
                 J = K*Jt - eye(length(v));
                 v = v0 - J\e;
                 v0 = v;
                 iter = iter-1;      
             end
             I = nonlinearity(obj,v);          
           end

           function obj = calc_steady_state(obj)
             N = length(obj.A);
             if(isempty(obj.K))
               x1 = (eye(N)-obj.A)\(obj.B*obj.U); 
             else
               Kss = obj.K + obj.G/(eye(N)-obj.A)*obj.C;
               pss = (obj.G/(eye(N)-obj.A)*obj.B+obj.H) * obj.U;
               obj.v = pss;
               [obj.v, I] = solve_nonlinear_func(obj,pss, Kss);
               x1 = (eye(N)-obj.A)\(obj.B*obj.U + obj.C*I);
             end
             obj.x = [x1 x1];
           end
         
           % build the incidence matrixes and state space model from components structure 
           function obj = buildModel(obj, components, components_count)
            
             if(nargin < 3)
               components_count.numCapacitors = 0;
               components_count.numResistors = 0;
               components_count.numInputPorts = 0;
               components_count.numOutputPorts = 0;
               components_count.numNonlinearComponents = 0;
               components_count.numPotmeters = 0;
               components_count.numOPAs = 0;
               components_count.numNodes = 0;

               for i = 1:length(components)
                  for n = 1:length(components(i).nodes)
                     if(components(i).nodes(n) > components_count.numNodes)
                        components_count.numNodes = components(i).nodes(n);
                     end
                  end
                
                  switch(components(i).type)
                    case 'res'
                        components_count.numResistors = components_count.numResistors+1;
                    case 'cap'
                        components_count.numCapacitors = components_count.numCapacitors+1;
                    case  'ind'
                        components_count.numCapacitors = components_count.numCapacitors+1;  % similar the cap, shares the property 
                    case 'opa'
                        components_count.numOPAs = components_count.numOPAs+1;
                    case  'in_'
                        components_count.numInputPorts = components_count.numInputPorts+1;
                    case 'out'
                        components_count.numOutputPorts = components_count.numOutputPorts+1;
                    case 'pot'
                        components_count.numPotmeters = components_count.numPotmeters+1;
                    case 'trd'
                       components_count.numNonlinearComponents = components_count.numNonlinearComponents+2; % two port component
                    case 'ptd'
                       components_count.numNonlinearComponents = components_count.numNonlinearComponents+2; % two port component
                  end  
               end
 
             end
             % build incidence matrixes   
             Nr = zeros(components_count.numResistors,components_count.numNodes);
             Gr = zeros(components_count.numResistors,components_count.numResistors);            
             Nx = zeros(components_count.numCapacitors,components_count.numNodes);
             Gx = zeros(components_count.numCapacitors,components_count.numCapacitors);
             Z = zeros(components_count.numCapacitors,components_count.numCapacitors);
             Nu = zeros(components_count.numInputPorts,components_count.numNodes);
             No = zeros(components_count.numOutputPorts,components_count.numNodes);
             Nn = zeros(components_count.numNonlinearComponents,components_count.numNodes);
             Nv = zeros(components_count.numPotmeters,components_count.numNodes); % not supported yet
             Nopai  = zeros(components_count.numOPAs,components_count.numNodes);
             Nopao  = zeros(components_count.numOPAs,components_count.numNodes);               
               
             obj.U = zeros(components_count.numInputPorts,1);

             numCapacitorsandInductors = 0;
             numResistors = 0;
             numInputPorts = 0;
             numOutputPorts = 0;
             numNonlinearComponents = 0;
             numPotmeters = 0;
             numOPAs = 0;

             for i = 1:length(components) % iterate all components
                if(strcmp(components(i).type, 'res')) % this is resistor
                    numResistors = numResistors+1;
                    if(components(i).nodes(1,1) > 0) % first node
                        Nr(numResistors,components(i).nodes(1,1)) = 1;
                    end
                    if(components(i).nodes(1,2) > 0)% second node
                        Nr(numResistors,components(i).nodes(1,2)) = -1;
                    end
                    Gr(numResistors,numResistors) = 1/components(i).value;
               elseif(strcmp(components(i).type, 'cap')) % this is capacitor
                    numCapacitorsandInductors = numCapacitorsandInductors+1;
                    Z(numCapacitorsandInductors,numCapacitorsandInductors) = 1; 
                    Gx(numCapacitorsandInductors,numCapacitorsandInductors) = 2*components(i).value/obj.T; 
                    if(components(i).nodes(1,1) > 0)
                        Nx(numCapacitorsandInductors,components(i).nodes(1,1)) = 1;
                    end
                    if(components(i).nodes(1,2) > 0)
                        Nx(numCapacitorsandInductors,components(i).nodes(1,2)) = -1;
                    end
                elseif(strcmp(components(i).type, 'ind')) % this is inductor
                    % similar the cap, shares some properties
                    numCapacitorsandInductors = numCapacitorsandInductors+1;
                    if(components(i).nodes(1,1) > 0)
                        Nx(numCapacitorsandInductors,components(i).nodes(1,1)) = 1;
                    end
                    if(components(i).nodes(1,2) > 0)
                        Nx(numCapacitorsandInductors,components(i).nodes(1,2)) = -1;
                    end
                    Gx(numCapacitorsandInductors,numCapacitorsandInductors) = obj.T/(components(i).value*2);
                    Z(numCapacitorsandInductors,numCapacitorsandInductors) = -1; 
                elseif(strcmp(components(i).type, 'in_')) % this is input port
                    numInputPorts = numInputPorts+1;
                    if(components(i).nodes(1,1) > 0)
                        Nu(numInputPorts,components(i).nodes(1,1)) = 1;
                    end
                    if(components(i).nodes(1,2) > 0)
                        Nu(numInputPorts,components(i).nodes(1,2)) = -1;
                    end
                    obj.U(numInputPorts,1) = components(i).value;
                elseif(strcmp(components(i).type, 'out')) % this is output port
                    numOutputPorts = numOutputPorts+1;
                    if(components(i).nodes(1,1) > 0)
                        No(numOutputPorts,components(i).nodes(1,1)) = 1;
                    end
                    if(components(i).nodes(1,2) > 0)
                        No(numOutputPorts,components(i).nodes(1,2)) = -1;
                    end
                elseif(strcmp(components(i).type, 'pot')) % this is potmeter
                    numPotmeters = numPotmeters+1;
                    % not omplemented yet
                    
                elseif(strcmp(components(i).type, 'opa')) % this is OPA
                    numOPAs = numOPAs+1;
                    if(components(i).nodes(1,1) > 0)
                        Nopai(numOPAs,components(i).nodes(1,1)) = 1;
                    end
                    if(components(i).nodes(1,2) > 0)
                        Nopai(numOPAs,components(i).nodes(1,2)) = -1;
                    end        
                    Nopao(numOPAs,components(i).nodes(2,1)) = 1;
                elseif(strcmp(components(i).type, 'trd')) %this is triode
                    % grid to cathode
                    numNonlinearComponents = numNonlinearComponents+1;       
                    if(components(i).nodes(1,1) > 0)
                        Nn(numNonlinearComponents,components(i).nodes(1,1)) = 1;
                    end
                    if(components(i).nodes(1,2) > 0)
                        Nn(numNonlinearComponents,components(i).nodes(1,2)) = -1;
                    end
                    % plate to cathode
                    numNonlinearComponents = numNonlinearComponents+1; 
                    if(components(i).nodes(2,1) > 0)
                        Nn(numNonlinearComponents,components(i).nodes(2,1)) = 1;
                    end
                    if(components(i).nodes(2,2) > 0)
                        Nn(numNonlinearComponents,components(i).nodes(2,2)) = -1;
                    end      
          %       elseif(strcmp(components(i).type, 'ptd')) % this is pentode
          %          % grid to cathode
          %          numNonlinearComponents = numNonlinearComponents+1;       
          %          if(components(i).nodes(1,1) > 0)
          %              Nn(numNonlinearComponents,components(i).nodes(1,1)) = 1;
          %          end
          %          if(components(i).nodes(1,2) > 0)
          %              Nn(numNonlinearComponents,components(i).nodes(1,2)) = -1;
          %          end                
          %          % screen to cathode
          %          numNonlinearComponents = numNonlinearComponents+1;       
          %          if(components(i).nodes(2,1) > 0)
          %              Nn(numNonlinearComponents,components(i).nodes(2,1)) = 1;
          %          end
          %          if(components(i).nodes(2,2) > 0)
          %              Nn(numNonlinearComponents,components(i).nodes(2,2)) = -1;
          %          end
          %          % plate to cathode
          %          numNonlinearComponents = numNonlinearComponents+1; 
          %          if(components(i).nodes(3,1) > 0)
          %              Nn(numNonlinearComponents,components(i).nodes(3,1)) = 1;
          %          end
          %          if(components(i).nodes(3,2) > 0)
          %              Nn(numNonlinearComponents,components(i).nodes(3,2)) = -1;
          %          end
                end      
             end

             obj = makeDKMatrices(obj,Nr,Gr, Nx, Gx, Nn, Nu, No,Z, Nopai, Nopao);
             obj = calc_steady_state(obj);
          end
          % get output signal for sinus input
          function [out, t] = get_processed_sinus(obj, amplitude, freq, duration)
              N = duration/obj.T;
              t = linspace(0, N-1, N)*obj.T;
              in = amplitude*sin(2*pi*freq*t);
              out = obj.process(in');
          end
          % show output signal for sinus input
          function show_processed_sinus(obj, amplitude, freq, duration)
              [out, t] = get_processed_sinus(obj, amplitude, freq, duration);
              figure;
              plot(t, out);
              grid on;
              xlabel('Time [s]');
              ylabel('Output [V]');
          end
          % get frequency response of the system
          function [H, w] = get_frequency_response(obj)
             in = [1, zeros(1, 4095)];
             out = obj.process(in');
             [H, w] = freqz(out, 1, 4096, 1/obj.T);
          end
          % show frequency response of the system
          function show_frequency_response(obj)
              [HH, w] = obj.get_frequency_response();
              figure;
              semilogx(w, 20*log10(abs(HH)));
              grid on;
              xlabel('Frequency [Hz]');
              ylabel('Maginute [dB]');          
          end
       end
end