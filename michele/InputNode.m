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
            node.ia.SetNodeActivation(node.index, values);
        end
        
        function size = GetInputSize(node)
            size = node.inputSize;
        end
    end
    
end

