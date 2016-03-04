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
              
        
        im_bootstraping         % N x 1 array determining whether an intentional module is bootstrabing or not
        
        im_type
        
        im_ics
        
        im_ics_size
        
        im_ca                   % N x OUT matrix containing categories activation
        im_input_matrix
        
        im_output_size
        im_input_size
        
        im_count
        
        im_max_size
    end
    
    properties
       context
       receptors
       receptors_source
    end
    
    properties
        CountIntentionalModules
        MaxSize
    end
    
    methods
        function ia = IntentionalArchitecture()
            k = 2;
            maxSize = 20;
            
            ia.im_output_size = 10;
            ia.im_input_size = k * ia.im_output_size;
            ia.im_ics_size = 5;
            
            ia.im_max_size = maxSize;
            
            ia.context = SOM_Context(20, ia.im_output_size * ia.im_max_size, 10);
            
            ia.receptors = repmat(SOM_Receptor(ia.context,0), ia.im_output_size, ia.im_max_size );
            ia.receptors_source = zeros(1,  ia.im_max_size);
            
            
            ia.im_connections = zeros(maxSize, maxSize);
            
            ia.im_bootstraping = zeros(maxSize, 1);
            
            ia.im_type = zeros(maxSize, 1);
            
            ia.im_ics = rand(maxSize, ia.im_ics_size, ia.im_input_size);
        
            ia.im_ca = rand(ia.im_max_size, ia.im_output_size);
            
            ia.im_input_matrix = zeros(maxSize, ia.im_input_size, ia.im_output_size);
            
            ia.im_count = 1;
            
            
            
            ia.NewIntentionalModule([1 4]);
            ia.NewIntentionalModule([2 3]);
            ia.NewIntentionalModule([1 2]);
            ia.NewIntentionalModule([1 2]);
            ia.NewIntentionalModule([3 4]);
            ia.NewIntentionalModule([3 2]);
            ia.NewIntentionalModule([5 4]);
            ia.NewIntentionalModule([2 3]);
            ia.NewIntentionalModule([6 5]);
            ia.NewIntentionalModule([4 3]);
        end
        
        function size = get.MaxSize(ia)
            size = length(ia.im_bootstraping);
        end
        
        function count = get.CountIntentionalModules(ia)
            count = ia.im_count - 1;
        end
        
        function im = NewIntentionalModule(ia, inputs)
            
            if ia.CountIntentionalModules() >= ia.MaxSize()
                im = 0;
                return
            end
            
            index = ia.im_count;
            ia.im_count = ia.im_count + 1;
            ia.im_type(index) = ia.TYPE_IM;
            
            im = IntentionalModule(ia, index);
            
            ia.IM_SetBootstraping(index, 1);
            
            ia.im_connections(index, inputs) = 1;
            
            
            ia.NewContextNode(index);
            
            UpdateIntentionalNode(ia, index, ia.im_output_size);
        end
        
        function NewContextNode(ia, im_index)
            
            index = ia.im_count;
            ia.im_count = ia.im_count + 1;
            
            ia.im_type(index) = ia.TYPE_CONTEXT;
            
            ia.receptors_source(index) = im_index;
            
            for ii = 1:ia.im_output_size
                r = ia.context.AddReceptor();
                ia.receptors(ii, index) = r;
            end
            
            UpdateContextNode(ia, index, ia.im_output_size);
        end
        
        function Update(ia)
            
            %Update activations
            ca_size = ia.im_output_size;
            type = ia.im_type;
            
            for ii = 1:ia.CountIntentionalModules()
                switch type(ii)
                    case ia.TYPE_INPUT
                        ia.UpdateInputNode(ii, ca_size);
                    case ia.TYPE_CONTEXT
                        ia.UpdateContextNode(ii, ca_size);
                    case ia.TYPE_IM
                        ia.UpdateIntentionalNode(ii, ca_size);
                end
            end
            
            ia.context.Update();
        end
        
        
        
        function UpdateIntentionalNode(ia, index, activations_size)
            
            in = ia.im_input_matrix(index) * reshape(transpose(ia.im_ca(ia.im_connections(index,:) == 1,:)), ia.im_input_size,1);
            
            w = reshape(ia.im_ics(index,:,:),ia.im_ics_size,ia.im_input_size) * in;
            
            % Activations are a function of the distance between vector w 
            % and the centroids
            
            
            ia.im_ca(index,:) = rand(activations_size, 1);
        end
        
        function UpdateContextNode(ia, index, activations_size)
            
            
            for ii = 1: ia.im_output_size
               ia.im_ca(index, ii) = ia.receptors(ii, index).GetActivation();
               ia.receptors(ii, index).SetActivation( ia.im_ca(ia.receptors_source(index), ii));
            end
            
            
        end
        
        function UpdateInputNode(ia, index, activations_size)
            
            % we read random values
            ia.im_ca(index,:) = rand(activations_size, 1);
        end
        
    end
    
    
    methods
        % Methods used by the intentional modules to access their data
        function bs = IM_IsBootstraping(ia, index)
            bs = ia.im_bootstraping(index);
        end
        
        function IM_SetBootstraping(ia, index, val)
            ia.im_bootstraping(index) = val;
        end
        
        function a = IM_GetActivation(ia, index)
            a = ia.im_activations(index);
        end
    end
    
    methods
        function plot(ia)
            while(1)
                ia.Update();
                bar3(ia.im_ca);
                pause(0.04);
            end
        end
    end
end

