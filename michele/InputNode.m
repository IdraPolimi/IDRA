classdef InputNode < handle
    %INPUTNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        index
        ia
        inputSize
    end
    
    methods
        function node = InputNode(intentionalArchitecture, index, inputSize)
            node.ia = intentionalArchitecture;
            node.index = index;
            node.inputSize = inputSize;
        end
        
        function SetInput(node, values)
            if length(values) < node.inputSize
                values = [values, zeros(node.inputSize - length(values))];
            end
            values = values(1 : node.inputSize);
            node.ia.im_activations(node.index) = max(values);
<<<<<<< HEAD
            node.ia.SetNodesActivation(node.index, values);
=======
            node.ia.SetNodeActivation(node.index, values);
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
        end
        
        function size = GetInputSize(node)
            size = node.inputSize;
        end
    end
    
end

