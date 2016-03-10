classdef IntentionalArchitecture < handle
    %IDRA INTENTIONALARCHITECTURE
    
    properties
       TYPE_INPUT = 1
       TYPE_CONTEXT = 2
       TYPE_IM = 3
    end
    
    properties
        im_connections          % N x N parse connection matrix containing the connections between intentional 
                                % modules
              
        im_activations
        im_bootstraping         % N x 1 array determining whether an intentional module is bootstrabing or not
        
        
        im_type
        
        im_ica
        
        im_ica_size
        
        im_ca                   % N x OUT matrix containing categories activation
        
        im_output_size
        im_input_size
        
        im_count
        
        im_max_size
        
        
        im_gathered_input
        im_gathered_input_size
    end
    
    properties
       context
       receptors_source
       receptors_indeces
    end
    
    properties
        CountNodes
        MaxSize
        UseGPU
    end
    
    methods
        function ia = IntentionalArchitecture(k, categoriesPerModule, icaSize)
            maxSize = 1;
            ia.im_output_size = categoriesPerModule;
            ia.im_input_size = k * ia.im_output_size;
            ia.im_ica_size = ia.im_output_size;%icaSize;
            ia.im_max_size = maxSize;
            
            ia.context = SOM_Context(20, ia.im_output_size * ia.im_max_size, 10);
            
            ia.receptors_source = zeros(ia.im_max_size, 1);
            ia.receptors_indeces = zeros(ia.im_max_size, ia.im_output_size);
            
            ia.im_connections = zeros(maxSize, maxSize);
            
            ia.im_bootstraping = zeros(maxSize, 1);
            
            ia.im_activations = zeros(maxSize, 1);
            
            ia.im_type = zeros(maxSize, 1);
            
            ia.im_ica = zeros(maxSize, ia.im_ica_size, ia.im_input_size);
        
            ia.im_ca = rand(ia.im_max_size, ia.im_output_size);
            
            ia.im_ca(1, :) = zeros(ia.im_output_size, 1);
            ia.im_count = 2;
            
            ia.im_gathered_input = zeros(ia.im_max_size, ia.im_input_size,100);
            ia.im_gathered_input_size = ones(ia.im_max_size,1);
            
            ia.UseGPU = 0;
        end
        
        function size = get.MaxSize(ia)
            size = length(ia.im_bootstraping);
        end
        
        function count = get.CountNodes(ia)
            count = ia.im_count;
        end
        
        function res = get.UseGPU(ia)
           res = ia.UseGPU ~= 0;
        end
        
        function set.UseGPU(ia, val)
           ia.UseGPU = val;
           r = ia.UseGPU();
           ia.context.UseGPU = r;
        end
       
        function Update(ia)
            ia.UpdateInputNodes();
            ia.UpdateIntentionalNodes();
            ia.UpdateContextNodes();
            ia.UpdateNodesActivation();
        end
        
        
        
    end
    
    methods (Access = public)
        %Node creation methods
        
        function node = NewFilterNode(ia, filterFunction)
            
            index = ia.NextIndex(ia.TYPE_INPUT);
            
            if index < 1
                node = 0;
                return;
            end
            
            node = FilterNode(ia, index, ia.im_output_size, filterFunction);
            
        end
        
        function node = NewIntentionalModule(ia, inputs)
            inputs = unique(inputs);
            k = ia.im_input_size / ia.im_output_size;
            input_length = length(inputs);
            
            if input_length < k
                inputs = [inputs, ones(1, k - input_length) ];
            end
            
            inputs = inputs(1:k);
            
            index = ia.NextIndex(ia.TYPE_IM);
            
            if index < 1
                node = 0;
                return;
            end
            
            node = IntentionalModule(ia, index);
            
            ia.SetBootstraping(index, 1);
            
            ia.im_connections(index, inputs) = 1;
            
            ia.NewContextNode(index);
        end
        
    end
    
    
    methods (Access = public)
        % Methods used by the nodes to access their data
        
        function bs = IsBootstraping(ia, indeces)
            bs = ia.im_bootstraping(indeces);
        end
        
        function SetBootstraping(ia, indeces, values)
            ia.im_bootstraping(indeces) = values;
        end
        
        % Getter for the activations of the nodes with the given indeces.
        % InputNode:        activations are it's input
        % IntentionalNode : activations are it's output categories
        % ContextNode:      activations are the values of the context's
        % som receptor
        function a = GetNodesActivation(ia, indeces)
            a = ia.im_activations(indeces);
        end
        
        % Setter for the activations of the nodes' categories.
        % InputNode:        categories activations are it's input
        % IntentionalNode : categories activations are it's output categories
        % ContextNode:      categories activations are the values of the context's
        % som receptor
        function SetCategoriesActivation(ia, indeces, values)
            ia.im_ca(indeces,:) = values;
        end
        
    end
    
    methods (Access = private)
        
        function NewContextNode(ia, im_index)
            
            index = ia.NextIndex(ia.TYPE_CONTEXT);
            
            if index < 1
                return;
            end
            
            ia.receptors_source(index) = im_index;
            
            ia.receptors_indeces(index, :) = ia.context.NextAvailableIndeces(ia.im_output_size);
            
        end
        
            
        
        % Allocates and returns the first available index for a new
        % node. A return value of -1 means that the intentional
        % architecture is full.
        function index = NextIndex(ia, nodeType)
            while ia.CountNodes() >= ia.MaxSize()
                ia.DoubleSize();
            end
            
            index = ia.im_count;
            ia.im_count = ia.im_count + 1;
            
            ia.im_type(index) = nodeType;
        end
        
        function UpdateInputNodes(~)
            %indeces = ia.im_type(:) == ia.TYPE_INPUT;
            % ia.im_ca(index,:) = rand(activations_size, 1);
        end
        
        function UpdateIntentionalNodes(ia)
            
            type = ia.im_type;
            ca = ia.im_ca;
            conn = ia.im_connections;
            indeces = find(type == ia.TYPE_IM);
            
            res  = zeros(length(indeces), size(ia.im_ca, 2));
            
            k = ia.im_input_size / ia.im_output_size;
            
            for ii = 1:length(indeces)
                index = indeces(ii);
                in_nodes = conn(index,:) == 1;
            	in = ca(in_nodes,:);
                kk = size(in, 1) - k;
                in = cat(1, reshape(in, 1, ia.im_input_size)', zeros(ia.im_input_size * kk, 1));
                
                
                if ia.IsBootstraping(index)
                    % If the module is bootstraping
                    
                    if ia.im_gathered_input_size(index) >= size(ia.im_gathered_input,3)
                        % If we have enough samples we perform ica
                        
                        sinin = reshape(ia.im_gathered_input(index,:,:), ia.im_input_size, size(ia.im_gathered_input,3));
                        
                        [~, ~, W] = ica(sinin, ia.im_ica_size);
                        ia.im_ica(index,:,:) = W;
                        ia.SetBootstraping(index,0);
                    else
                        % Otherwise we accumulate the sample if input
                        % modules are activated
                        if min(ia.im_activations(in_nodes)) > 0.1;
                            ia.im_gathered_input(index, :, ia.im_gathered_input_size(index)) = in;
                            ia.im_gathered_input_size(index) = ia.im_gathered_input_size(index) + 1;
                        end
                    end
                else
                    % If the module is not bootstraping we process the
                    % sample through kmeans
                    w = reshape(ia.im_ica(index,:,:), ia.im_ica_size, ia.im_input_size);
                    res(ii,:) = w * in;
                    
%                     rr = kmeans(in, zeros(ia.im_output_size,1));
                    res(ii,:) = abs(res(ii,:) ./max(abs(res(ii,:))));
                end
                
            end
            
            ia.im_ca(indeces,:) = res;
        end
        
        function UpdateContextNodes(ia)
            
            indeces = ia.im_type(:) == ia.TYPE_CONTEXT;
            
            idx = ia.receptors_indeces(indeces, :);
            r_indeces = idx;
            
            
            receptors_input = ia.im_ca(ia.receptors_source(indeces), :);
            ia.context.SetActivations(r_indeces, receptors_input);
            
            ia.context.Update();
            
            node_activations = ia.context.GetActivations(r_indeces);
            
            ia.im_ca(indeces, :) = node_activations;
            
        end
        
        function UpdateNodesActivation(ia)
            ia.im_activations = max(ia.im_ca, [], 2);
        end
        
        function DoubleSize(ia)
            
            curr_size = ia.im_max_size;
            new_size = 2 * curr_size;
            
            inc_size = new_size - curr_size;
            
            old = ia.im_connections;
            
            ia.im_connections = zeros(new_size, new_size);
            ia.im_connections(1:curr_size, 1:curr_size) = old;
                                
            ia.im_activations = cat(1, ia.im_activations, zeros(inc_size, 1));
            ia.im_bootstraping = cat(1, ia.im_bootstraping, zeros(inc_size, 1));
            
            ia.im_type = cat(1, ia.im_type, zeros(inc_size, 1));
            
            ia.im_ica = cat(1, ia.im_ica, zeros(inc_size, size(ia.im_ica, 2), size(ia.im_ica, 3)));

            ia.im_ca = cat(1, ia.im_ca, zeros(inc_size, ia.im_output_size));

            ia.receptors_source = cat(1, ia.receptors_source, zeros(inc_size, 1));
            
            ia.receptors_indeces = cat(1, ia.receptors_indeces, zeros(inc_size, size(ia.receptors_indeces,2)));
            
            ia.im_max_size = new_size;
            
            
            ia.im_gathered_input = cat(1,ia.im_gathered_input, zeros(inc_size, ia.im_input_size,100));
            ia.im_gathered_input_size = cat(1, ia.im_gathered_input_size, ones(inc_size,1));
            
           
            ia.context.DoubleSize();
        end
    end
    
   
end

