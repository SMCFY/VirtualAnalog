classdef Distortion < audioPlugin
    properties
        Gain = 0.5;
        Out = 0.5;
    end
    properties (Access=private)
        model
    end
    properties (Constant)
        PluginInterface = audioPluginInterface(...
            audioPluginParameter('Gain',...
            'DisplayName',...
            'Gain',...
            'Mapping',{'lin',0,1},'Label',...
            '%'),...
            audioPluginParameter('Out',...
            'DisplayName',....
        'Output',...
            'Mapping',{'lin',0,1},'Label','%'));
    end
    methods
        function plugin = Distortion
            plugin.model = distortionModel(plugin.getSampleRate);
        end
        function Output = process(plugin, in)
            [sig, ~] = plugin.model.process(in*plugin.Gain);
            Output = sig*plugin.Out;
            %Output = in*plugin.Out;
        end
        function reset(plugin)
            plugin.model = distortionModel(plugin.getSampleRate);
        end
        function set.Gain(plugin, val)
            plugin.Gain = val;
        end
        function set.Out(plugin, val)
            plugin.Out = val;
        end
    end
end