classdef ClassificationHelper
    
    properties
    end
    
    methods
        function ch = ClassificationHelper()
        
        end
        
        function [training_indeces, test_indeces, val_indeces] = SplitData(~, dataset, training_percentage, test_percentage)
            ptrain = max(0, min(1, training_percentage));
            ptest = max(0, min(1, test_percentage));
            
            data_length = length(dataset);
            train_length = floor(ptrain * data_length);
            test_length = floor(ptest * data_length);
            
            indeces = 1:length(dataset);
            
            itrain = randsample(1:length(indeces), train_length);
            
            training_indeces = indeces(itrain);
            indeces(itrain) = [];
            
            
            
            itest = randsample(1:length(indeces), test_length);
            
            test_indeces = indeces(itest);
            indeces(itest) = [];
            
            
            val_indeces = indeces;
        end
        
        function targets = GenerateTargets(~, dataset, column)
            column = dataset(:, column);
            
            classes = sort( unique(column) );
            nclasses = sum( classes );
            
            targets = zeros(length(column), nclasses);
            
            for ii = 1:nclasses
                c = classes(ii);
                targets(: , ii) = column == c;
            end
        end
        
        function [simout, icaout] = ProcessIntentionalModule(~, ia, input_index, im_index, dataset)
           

            data_length = length(dataset);
            
            
            for ii = 1:data_length
                ia.modules{input_index}.input = dataset(ii,:);
                ia.Update();
                simout(ii,:) = ia.GetModuleOutput(im_index);
            	im_module = ia.modules{im_index};

                icaout(ii,:) = ia.ProcessForward(im_module, im_module.input);
            end
           
        end
        
    end
    
end

