classdef FilterNode < handle
    %INPUTNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        index
        ia
        InputSize
        filter
    end
    
    methods
        function node = FilterNode(intentionalArchitecture, index, InputSize, filter)
            node.ia = intentionalArchitecture;
            node.index = index;
            node.InputSize = InputSize;
            node.filter = filter;
        end
        
        function valid = Test(node, inputs)
            out = node.filter(inputs);
            s = size(out, 1);
        	valid = s <= node.InputSize();
        end
        
        function SetInput(node, values)
            if length(values) < node.InputSize
                values = [values, zeros(node.InputSize - length(values))];
            end
            values = values(1 : node.InputSize);
            
            node.ia.SetCategoriesActivation(node.index, node.filter(values));
        end
        
        function size = get.InputSize(node)
            size = node.InputSize;
        end
    end
    
end

