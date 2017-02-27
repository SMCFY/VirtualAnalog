classdef flangerPlugin < audioPlugin
    properties
        Gain
        Output
    end
    properties (Access=private)
        flanger
    end
    properties (Constant)
        PluginInterface = audioPluginInterface(...
            audioPluginParameter('Gain',...
            'DisplayName',...
            'Gain',...
            'Mapping',{'lin',0,1},'Label',...
            '%'),...
            audioPluginParameter('Output',...
            'DisplayName',....
        'Output',...
            'Mapping',{'lin',0,1},'Label','%'));
    end
    methods
        function plugin = flangerPlugin()
            flanger = flangerModel(plugin.getSampleRate);
        end
        function reset(plugin)
            flanger = flangerModel(plugin.getSampleRate);
        end
        function Output = process(plugin, x)
            Output = x; 
        end
    end
end
