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
<<<<<<< HEAD
            as = im.intentionalArchitecture.GetNodesActivation(im.index);
=======
            as = im.intentionalArchitecture.GetNodeActivation(im.index);
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
        end
    end
end

