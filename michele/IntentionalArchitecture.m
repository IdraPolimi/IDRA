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
        
        im_ics
        
        im_ics_size
        
        im_ca                   % N x OUT matrix containing categories activation
        
        im_output_size
        im_input_size
        
        im_count
        
        im_max_size
    end
    
    properties
       context
       receptors_source
       receptors_indeces
    end
    
    properties
        CountNodes
        MaxSize
    end
    
    methods
<<<<<<< HEAD
        function ia = IntentionalArchitecture(k, categoriesPerModule)
            maxSize = 1;
            ia.im_output_size = categoriesPerModule;
=======
        function ia = IntentionalArchitecture(maxSize, k)
            
            ia.im_output_size = 10;
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
            ia.im_input_size = k * ia.im_output_size;
            ia.im_ics_size = 5;
            ia.im_max_size = maxSize;
            
            ia.context = SOM_Context(10, ia.im_output_size * ia.im_max_size, 7);
            
<<<<<<< HEAD
            ia.receptors_source = zeros(ia.im_max_size, 1);
=======
            ia.receptors_source = zeros(1,  ia.im_max_size);
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
            ia.receptors_indeces = zeros(ia.im_max_size, ia.im_output_size);
            
            ia.im_connections = zeros(maxSize, maxSize);
            
            ia.im_bootstraping = zeros(maxSize, 1);
            
            ia.im_activations = zeros(maxSize, 1);
            
            ia.im_type = zeros(maxSize, 1);
            
            ia.im_ics = rand(maxSize, ia.im_ics_size, ia.im_input_size);
        
            ia.im_ca = rand(ia.im_max_size, ia.im_output_size);
            
            ia.im_ca(1, :) = zeros(ia.im_output_size, 1);
            ia.im_count = 2;
            
        end
        
        function size = get.MaxSize(ia)
            size = length(ia.im_bootstraping);
        end
        
        function count = get.CountNodes(ia)
<<<<<<< HEAD
            count = ia.im_count;
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
        
        function node = NewInputNode(ia)
            
            index = ia.NextIndex(ia.TYPE_INPUT);
            
            if index < 1
                node = 0;
                return;
            end
            
            node = InputNode(ia, index, ia.im_output_size);
            
        end
        
        function node = NewIntentionalModule(ia, inputs)
            
            k = ia.im_input_size / ia.im_output_size;
            input_length = length(inputs);
            
            if input_length < k
                inputs = [inputs, ones(1, k - input_length) ];
            end
            
            index = ia.NextIndex(ia.TYPE_IM);
            
            if index < 1
                node = 0;
                return;
            end
            
            node = IntentionalModule(ia, index);
            
            ia.IM_SetBootstraping(index, 1);
            
            ia.im_connections(index, inputs) = 1;
            
            ia.NewContextNode(index);
        end
        
    end
    
    
    methods (Access = public)
        % Methods used by the nodes to access their data
        
        function bs = IM_IsBootstraping(ia, index)
            bs = ia.im_bootstraping(index);
        end
        
        function IM_SetBootstraping(ia, index, val)
            ia.im_bootstraping(index) = val;
        end
        
        function a = GetNodesActivation(ia, indeces)
            % Getter for the activations of the node with the given index.
            % InputNode:        activations are it's input
            % IntentionalNode : activations are it's output categories
            % ContextNode:      activations are the values of the context's
            % som receptor
            a = ia.im_activations(indeces);
        end
        
        function SetNodesActivation(ia, indeces, values)
            % Setter for the activations of the node with the given index.
            % InputNode:        activations are it's input
            % IntentionalNode : activations are it's output categories
            % ContextNode:      activations are the values of the context's
            % som receptor
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
        
        function index = NextIndex(ia, nodeType)
            % Allocates and returns the first available index for a new
            % node. A return value of -1 means that the intentional
            % architecture is full
            while ia.CountNodes() >= ia.MaxSize()
                ia.DoubleSize();
            end
            
            index = ia.im_count;
            ia.im_count = ia.im_count + 1;
            
            ia.im_type(index) = nodeType;
        end
        
        function UpdateInputNodes(ia)
            indeces = ia.im_type(:) == ia.TYPE_INPUT;
            % ia.im_ca(index,:) = rand(activations_size, 1);
        end
        
        function UpdateIntentionalNodes(ia)
            
            type = ia.im_type;
            ca = ia.im_ca;
            conn = ia.im_connections;
            indeces = find(type == ia.TYPE_IM);
            
            res  = zeros(length(indeces), size(ia.im_ca, 2));
            
            
            for ii = 1:length(indeces)
                index = indeces(ii);
            	in = ca(conn(index,:) == 1,:);
            	in = max(in);
            	res(ii,:) = in;
            end
            
            ia.im_ca(indeces,:) = res;
        end
        
        function UpdateContextNodes(ia)
            
            indeces = ia.im_type(:) == ia.TYPE_CONTEXT;
            
            idx = ia.receptors_indeces(indeces, :);
            r_indeces = idx;
=======
            count = ia.im_count - 2;
        end
        
        
       
        function Update(ia)
            
            %Update activations
            ca_size = ia.im_output_size;
            type = ia.im_type;
            
            for ii = 1:ia.CountNodes()
                switch type(ii)
                    % case ia.TYPE_INPUT
                    %    ia.UpdateInputNode(ii, ca_size);
                    case ia.TYPE_IM
                        ia.UpdateIntentionalNode(ii, ca_size);
                end
            end
            
            % ia.UpdateInputNodes();
            ia.UpdateContextNodes();
            
            ia.context.Update();
        end
        
        function UpdateIntentionalNode(ia, index, activations_size)
            
            in = reshape(transpose(ia.im_ca(ia.im_connections(index,:) == 1,:)), ia.im_input_size,1);
            
            w = reshape(ia.im_ics(index,:,:), ia.im_ics_size, ia.im_input_size) * in;
            
            % Activations are a function of the distance between vector w 
            % and the centroids
            in = ia.im_ca(ia.im_connections(index,:) == 1,:);
            in = max(in);
            ia.im_ca(index,:) = in;
            
            ia.im_activations(index) = max( in );
        end
        
        function UpdateContextNodes(ia)
            
            indeces = ia.im_type(:) == ia.TYPE_CONTEXT;
            
            idx = ia.receptors_indeces(indeces, :);
            r_indeces = idx;
            
            ia.im_ca(indeces, :) = ia.context.GetActivations(r_indeces);
            
            receptors_input = ia.im_ca(ia.receptors_source(indeces), :);
            
            ia.context.SetActivations(r_indeces, receptors_input);
            
        end
        
        function UpdateInputNodes(ia)
            indeces = ia.im_type(:) == ia.TYPE_INPUT;
            % ia.im_ca(index,:) = rand(activations_size, 1);
        end
        
    end
    
    methods (Access = public)
        %Node creation methods
        
        function node = NewInputNode(ia)
            
            index = ia.NextIndex(ia.TYPE_INPUT);
            
            if index < 1
                node = 0;
                return;
            end
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
            
            node = InputNode(ia, index, ia.im_output_size);
            
<<<<<<< HEAD
            receptors_input = ia.im_ca(ia.receptors_source(indeces), :);
            ia.context.SetActivations(r_indeces, receptors_input);
            
            ia.context.Update();
            
            node_activations = ia.context.GetActivations(r_indeces);
            
            ia.im_ca(indeces, :) = node_activations;
            
=======
        end
        
        function node = NewIntentionalModule(ia, inputs)
            
            k = ia.im_input_size / ia.im_output_size;
            input_length = length(inputs);
            
            if input_length < k
                inputs = [inputs, ones(k - input_length, 1) ];
            end
            
            index = ia.NextIndex(ia.TYPE_IM);
            
            if index < 1
                node = 0;
                return;
            end
            
            node = IntentionalModule(ia, index);
            
            ia.IM_SetBootstraping(index, 1);
            
            ia.im_connections(index, inputs) = 1;
            
            ia.NewContextNode(index);
            
            UpdateIntentionalNode(ia, index, ia.im_output_size);
        end
        
    end
    
    
    methods (Access = public)
        % Methods used by the nodes to access their data
        
        function bs = IM_IsBootstraping(ia, index)
            bs = ia.im_bootstraping(index);
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
        end
        
        function UpdateNodesActivation(ia)
            ia.im_activations = max(ia.im_ca, [], 2);
        end
        
<<<<<<< HEAD
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
            
            ia.im_ics = cat(1, ia.im_ics, zeros(inc_size, size(ia.im_ics, 2), size(ia.im_ics, 3)));

            ia.im_ca = cat(1, ia.im_ca, zeros(inc_size, ia.im_output_size));

            ia.receptors_source = cat(1, ia.receptors_source, zeros(inc_size, 1));
            
            ia.receptors_indeces = cat(1, ia.receptors_indeces, zeros(inc_size, size(ia.receptors_indeces,2)));
            
            ia.im_max_size = new_size;
           
            ia.context.DoubleSize();
=======
        function a = GetNodeActivation(ia, index)
            % Getter for the activations of the node with the given index.
            % InputNode:        activations are it's input
            % IntentionalNode : activations are it's output categories
            % ContextNode:      activations are the values of the context's
            % som receptor
            a = ia.im_activations(index);
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
        end
        
        function SetNodeActivation(ia, index, values)
            % Setter for the activations of the node with the given index.
            % InputNode:        activations are it's input
            % IntentionalNode : activations are it's output categories
            % ContextNode:      activations are the values of the context's
            % som receptor
            ia.im_ca(index,:) = values;
        end
    end
    
<<<<<<< HEAD
=======
    methods (Access = private)
        
        function NewContextNode(ia, im_index)
            
            index = ia.NextIndex(ia.TYPE_CONTEXT);
            
            if index < 1
                return;
            end
            
            ia.receptors_source(index) = im_index;
            
            ia.receptors_indeces(index, :) = ia.context.nextAvailableIndeces(ia.im_output_size);
            
        end
        
        function index = NextIndex(ia, nodeType)
            % Allocates and returns the first available index for a new
            % node. A return value of -1 means that the intentional
            % architecture is full
            if ia.CountNodes() >= ia.MaxSize()
                index = -1;
                return
            end
            
            index = ia.im_count;
            ia.im_count = ia.im_count + 1;
            
            ia.im_type(index) = nodeType;
        end
        
        function DoubleSize(ia)
            
        end
    end
    
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
   
end

