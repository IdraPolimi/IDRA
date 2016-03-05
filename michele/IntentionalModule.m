classdef IntentionalModule
    %IDRA INTENTIONALMODULE
    
    properties
       index 
    end
    
    properties 
        Activation
        IsBootstraping
    end
    
    properties
       intentionalArchitecture 
    end
    
    methods (Access = public)
        
        function im = IntentionalModule(intentionalArchitecture, index)
            im.intentionalArchitecture = intentionalArchitecture;
            im.index = index;
        end
    end
    
    methods
        
        function bs = get.IsBootstraping(im)
            bs = im.intentionalArchitecture.IM_IsBootstraping(im.index);
        end
        
        function FinishBootstraping(im)
            im.intentionalArchitecture.IM_SetBootstraping(im.index, 0);
        end
        
        function as = get.Activation(im)
            as = im.intentionalArchitecture.GetNodeActivation(im.index);
        end
    end
end

