classdef IA < handle
    
    properties ( Access = private )
       TYPE_INPUT = 1
       TYPE_CONTEXT = 2
       TYPE_IM = 3
       TYPE_BOOTSTRAPING = 4
       TYPE_EMPTY = 0
    end
    
    
    properties 
        context
        modules
        modules_type
        next_index
        connections
        
        threshold
        graphs
        network_graph
        network_graph_count
        network_graph_plot
        network_graph_fig_no
        
        
        gain
        centroids_multiplier
        
        sampling_percentage
        
        wm
    end
    
    properties
        UseGPU
        im_ca
    end
    
    methods
        
        function ia = IA(treshold, gain)
            size = 1;
            
            ia.context = SOM_Context(50, 80, size, 20);
            
            ia.UseGPU = 0;
            
            ia.modules = cell(size,1);
            ia.next_index = 1;
            ia.modules_type = zeros(size,1);
            ia.connections = zeros(size, 1);
            ia.threshold = treshold;
            ia.gain = gain;
            
            ia.centroids_multiplier = 1;
            
            ia.sampling_percentage = 1;
            
            ia.wm = WM();
            ia.wm.init();
            ia.graphs = cell(size,1);
            
            
            count = ia.CountNodes();
            ia.network_graph = digraph(ia.connections(1:count, 1:count));
            ia.network_graph_count = 0;
            ia.network_graph_fig_no = 42;
            
            figure(ia.network_graph_fig_no);
            ia.network_graph_plot = plot(ia.network_graph);
        end
        
        function set.UseGPU(ia, val)
           ia.UseGPU = val;
           r = ia.UseGPU();
           ia.context.UseGPU = r;
        end
        
        function c = CountNodes(ia)
            c = ia.next_index - 1;
        end
        
        function s = MaxSize(ia)
           s = length(ia.modules); 
        end
        
        function input_module = NewFilterNode(ia, input_size, filterFunction)
            index = ia.NextIndex(ia.TYPE_INPUT);
            module = [];
            module.input = zeros(input_size,1);
            module.output = zeros(input_size,1);
            module.activation = 1;
            module.reward = 0;
            module.output_changed = false;
            
            ia.modules{index} = module;
            input_module = FilterNode(ia, index, input_size, filterFunction);
        end
        
        function bs = IsBootstraping(ia, indeces)
            bs = ia.modules_type(indeces);
            
            bs = bs == ia.TYPE_BOOTSTRAPING;
        end
        
        function index = NewIntentionalModule(ia, sources, training_set_size, output_size)
            index = ia.NextIndex(ia.TYPE_BOOTSTRAPING);
            ia.connections(index, sources) = 1;
            input_size = ia.GetModuleOutputSize(sources);
            
            module = [];
            module.index = index;
            module.sources = sources;
            module.input = zeros( 1, input_size );
            module.output = zeros( 1, output_size );
            module.bootstraping = true;
            module.training_set = zeros(training_set_size, input_size);
            module.sampling_weights = ones(training_set_size,1);
            module.training_count = 0;
            module.ica = [];
            module.pca = [];
            module.centroids = [];
            module.centroids_mean_distance = [];
            module.activation = 0;
            module.output_changed = false;
            
            module.wm_index = ia.wm.NewWMModule(1, output_size, output_size);
            
            module.reward = 0;
            
            module.out_mask = zeros(1, output_size);
            
            ia.modules{index} = module;
        end
        
        function Update(ia)
            ia.UpdateInputModules();
            ia.UpdateIntentionalModules();
        	ia.UpdateContextModules();
            ia.UpdateGraph();
        end
        
    end
    
    methods
        
        function size = GetModuleOutputSize(ia, indeces)
            size = 0;
            for ii = 1:length(indeces)
                index = indeces(ii);
                size = size + length(ia.modules{index}.output);
            end
        end
        
        function size = GetModuleInputSize(ia, indeces)
            size = 0;
            for ii = 1:length(indeces)
                index = indeces(ii);
                size = size + length(ia.modules{index}.input);
            end
        end
        
        function out = GetModuleOutput(ia, indeces)
            out = [];
            for ii = 1:length(indeces)
                index = indeces(ii);
                out = cat(2, out, ia.modules{index}.output);
            end
        end
        
        function rewards = GetModuleReward(ia, indeces)
            rewards = [];
            for ii = 1:length(indeces)
                index = indeces(ii);
                rewards = cat(2, rewards, ia.modules{index}.reward);
            end
        end
        
        function SetModuleInput(ia, index, values)
           ia.modules{index}.input = values;
        end
        
        function parents = GetInputModules(ia, indeces)
            parents = ia.GetParentModules(indeces);
        end
        
        function childrens = GetChildrenModules(ia, indeces)
            childrens = find( any(ia.connections(:,indeces), 2) == true );
        end
        
        function parents = GetParentModules(ia, indeces)
            parents = find(ia.connections( indeces,:) == 1);
        end
        
        function siblings = GetSiblingModules(ia, indeces)
           parents = ia.GetParentModules(indeces);
           siblings = ia.GetChildrenModules(parents);
           siblings = siblings(siblings ~= indeces);
        end
        
        function layers_count = CountLayers(ia)
            inputs = find(all(ia.connections' == 0, 1));
            
            layers_count = 0;
            
            childrens = ia.GetChildrenModules(inputs);
            
            while ~isempty(childrens)
                layers_count = layers_count + 1;
                childrens = ia.GetChildrenModules(childrens);
            end
        end
        
        function booting = AreChildrenBootstraping(ia,index)
            childrens = ia.GetChildrenModules(index);
            
            booting = any( ia.IsBootstraping(childrens) );
        end
        
        function UpdateInputModules(ia)
            indeces = find(ia.modules_type == ia.TYPE_INPUT);
            
            for ii = 1:length(indeces)
                index = indeces(ii);
                module = ia.modules{index};
                
                module.output = module.input;
                
                ia.modules{index} = module;
            end
        end
        
        function UpdateIntentionalModules(ia)
            indeces = find(ia.modules_type == ia.TYPE_BOOTSTRAPING);
            
            for ii = 1:length(indeces)
                index = indeces(ii);
                ia.TrainIntentionalModule(index);
            end
            
            indeces = find(ia.modules_type == ia.TYPE_IM);
            
            for ii = 1:length(indeces)
                index = indeces(ii);
                module = ia.modules{index};
                
                input = ia.GetModuleOutput(module.sources);
                output = ia.ProcessForward(module,input);
                
                
                sim = ia.GetCentroidsDistance(module, ia.gain, output);
                
                output_size = length(module.output);
                
                children = ia.GetChildrenModules(index);
                bootstraping = any(ia.IsBootstraping(children));
                
                module.input = input;
                
                if ~isempty(children)
                    reward = mean( ia.GetModuleReward(children) );
                    module.reward = reward;
                end
                

                chunks = eye(output_size) .* repmat((sim > ia.threshold), output_size, 1);
                chunks( ~any(chunks,2), : ) = [];  %drop zeros rows
               
                if bootstraping
                   ia.wm.SetExplorationPercentage(module.wm_index, 1);
                else
                    if ~isempty(children)
                        ia.wm.SetExplorationPercentage(module.wm_index, 0.05);
                    end
                end
                
                
                retained_cluster = ia.wm.Update(module.wm_index, sim, chunks, module.reward);
                
                module.output_changed = false;
                
                if ~isempty(retained_cluster) && any(retained_cluster ~= module.out_mask);
                    module.out_mask = retained_cluster;
                    module.output_changed = true;
                end
                
                sim = sim .* module.out_mask;
                module.output = sim;
                
                module.activation = max(module.output);
                

                ia.modules{index} = module;
                
            end
            
        end
        
        function UpdateContextModules(ia)
            indeces = find(ia.modules_type == ia.TYPE_CONTEXT);
            
            if isempty(indeces)
                return;
            end
            
            for ii = 1:length(indeces)
                index = indeces(ii);
                module = ia.modules{index};
                
                src = module.source;
                input = ia.GetModuleOutput(src);
                ia.context.SetActivations(module.receptors, input);
            end
            
            ia.context.Update();
            
            for ii = 1:length(indeces)
                index = indeces(ii);
                receptors = ia.modules{index}.receptors;
                a = ia.context.GetActivations(receptors);
                ia.modules{index}.output = a;
                ia.modules{index}.activation = max(a);
            end
        end
      
        function UpdateCentroids(ia)
            
            curr = find(ia.modules_type == ia.TYPE_INPUT);
            layer = ia.GetChildrenModules(curr);
            
            while ~isempty(layer)
                act = ia.GetNodesActivation(layer);
                max_active = layer(act == max(act));
                max_active= max_active(1);
                other = layer(act ~= max(act));
                if act <= 0
                    break;
                end

                %---------------------------------------
                module = ia.modules{max_active};
                
                x = ia.ProcessForward(module, module.input);
                
                dists = ia.GetCentroidsDistance(module, ia.gain, x);
                
                lr = 10^-0.5;
                g = ia.gain;
                
                centroid_max_active = find(dists == max(dists));

                for jj = 1:size(centroid_max_active,1)
                    kk = centroid_max_active(jj);
                    
                    p = module.centroids(kk,:);

                    meand = max(10^-3, module.centroids_mean_distance(kk));

                    c = meand/sqrt(2*log(2));
                    llr = lr;
                    p = p + llr * exp( -1/(2*g*c^2) * (sum((x-p).^2)) ) * 1/(g*c^2) *(x - p).*p;
                    
                    ia.modules{max_active}.centroids(kk,:) = p;
                end
                
                for mm = 1: length(other)
                    index = other(mm);
                    module = ia.modules{index};
                    x = ia.ProcessForward(module, module.input);
                    dists = ia.GetCentroidsDistance(module, ia.gain, x);
                    centroid_max_active = find(dists == max(dists));
                    
                    for jj = 1:size(centroid_max_active,1)
                        kk = centroid_max_active(jj);
                        p = module.centroids(kk,:);

                        meand = max(10^-3, module.centroids_mean_distance(kk));

                        c = meand/sqrt(2*log(2));
                        llr = lr * dists(kk);
                        try
                        p = p - llr * exp( -1/(2*g*c^2) * (sum((x-p).^2)) ) * 1/(g*c^2) *(x - p).*p;
                        catch
                        end
                        
                        ia.modules{index}.centroids(kk,:) = p;
                    end
                end
                
                %---------------------------------------
                curr = layer;
                layer = ia.GetChildrenModules(curr);
            end
            
        end
        
        function full = UpdateTrainingSet(ia, index, input)
           module = ia.modules{index};
           count = module.training_count;
           
           if count < size(module.training_set,1)
               ia.modules{index}.training_set(count + 1,:) = input;
               ia.modules{index}.training_count = count + 1;
               full = false;
           else
              full = true; 
           end
        end
        
        function UpdateGraph(ia)
            
            count = ia.CountNodes();
            
            if count ~= ia.network_graph_count
                ia.network_graph_count = count;
                ia.network_graph = digraph(ia.connections(1:count, 1:count));

                figure(ia.network_graph_fig_no);
                ia.network_graph_plot = plot(ia.network_graph);
                highlight(ia.network_graph_plot, 1:count);
            end
            
            for ii = 1:count
                pp = ia.modules{ii}.activation;
                highlight(ia.network_graph_plot, ii, 'NodeColor', [1 - pp, pp, 0]);
            end
            highlight(ia.network_graph_plot,ia.network_graph,'EdgeColor',[0 0.4470 0.7410],'LineWidth',0.33);

            max_active_adj = ia.connections(1:count, 1:count);
            
            for ii = 1:count
                if ~ia.modules{ii}.output_changed
                    max_active_adj(:,ii) = 0;
                end
            end
            
            h = digraph(max_active_adj);
            highlight(ia.network_graph_plot, h, 'EdgeColor','black','LineWidth',2)
        end
        
        function a = GetModuleActivation(ia, indeces)
            l = length(indeces);
            a = zeros(1, l);
            
            for ii = 1:l
                a(ii) = ia.modules{indeces(ii)}.activation;
            end
        end
        
        function TrainIntentionalModule(ia, index)
            module = ia.modules{index};
            
            sources = module.sources;
            
            sa = ia.GetModuleActivation(sources);
            
            
            if any(ia.IsBootstraping(sources))
                return;
            end
            
            if max(sa) < ia.threshold
                return;
            end
            
            input = ia.GetModuleOutput(sources);
            
            
            if ia.UpdateTrainingSet(index, input)
                
                training_set = ia.modules{index}.training_set;
                training_set_size = size(training_set, 1);
                
                sampled_set_size = ceil(training_set_size * ia.sampling_percentage);
                
                w = ia.modules{index}.sampling_weights;
                
                samples = randsample(training_set_size, sampled_set_size, true,w);
                
                sampled_training_set = training_set(samples, :);
                sampled_training_set = sampled_training_set(randperm(size(sampled_training_set,1)),:);
                
                %---------------- MODULE TRAINING ------------------ begin
                sigin = sampled_training_set;
                
                [pc.coeff, pc.score, pc.latent, pc.tsquared, pc.explained, pc.mu] = pca(sigin);
                
                
                
                perc = cumsum(pc.latent) / sum(pc.latent);
                
                perc(perc >= 0.98) = 0;
                
                perc(perc > 0) = 1;
                perc(1:3) = 1;
                pc.coeff =  pc.coeff(:, logical(perc));
                
                pc.score = (sigin - repmat(pc.mu, size(sigin,1), 1)) * pinv(pc.coeff');
                
                [ica.ics, ica.A, ica.W] = fastica(pc.score, 'NumOfIc', 256);
                ica.ics = ica.ics ./ norm(ica.ics);
                ica.A = pc.score * pinv(ica.ics);
                
                
                k = ia.GetModuleOutputSize(index);
                kk = ceil(ia.centroids_multiplier * k);
                
                [centroids, ~, meand] = categorizeInput(ica.A, kk);
                
                samples = randsample(kk, kk - k);
                
                centroids(samples, :) = [];
                
                meand(samples) = [];
                
                
                ia.modules{index}.centroids = centroids;
                ia.modules{index}.centroids_mean_distance = meand';
                ia.modules{index}.ica = ica;
                ia.modules{index}.pca = pc;
                ia.modules{index}.bootstraping = false;
                ia.modules_type(index) = ia.TYPE_IM;
                %---------------- MODULE TRAINING ------------------ end
                
                module = ia.modules{index};
                
                current_output = ia.ProcessForward(module, input);
                figure(index * 10);
                
                hold on;
                tset_plot = ia.ProcessForward(module, sampled_training_set);
                
                for aa = size(tset_plot,2)+1:3
                    tset_plot(:,aa) = zeros(size(tset_plot,1),1);
                end
                for aa = size(centroids,2)+1:3
                    centroids(:,aa) = zeros(size(centroids,1),1);
                end
                for aa = size(current_output,2)+1:3
                    current_output(:,aa) = zeros(size(current_output,1),1);
                end
                ia.graphs{index}.training = scatter3(tset_plot(:,1 ),tset_plot(:, 2),tset_plot(:, 3), 'G');
                ia.graphs{index}.centroids = scatter3(centroids(:,1 ),centroids(:, 2),centroids(:, 3), 'B');
                ia.graphs{index}.output = scatter3(current_output(:,1 ),current_output(:, 2),current_output(:, 3), 'R');
                hold off;
                axis manual;
                grid on;
            end
        end
        
        function inputs = ProcessBackward(~, module, points)
            
            ics = module.ica.ics;
            
            pcs = module.pca;
            mu = pcs.mu;
            coeff = pcs.coeff';
            
            
            
            inputs = points * ics;
            
            inputs = (inputs * coeff) + repmat(mu, size(inputs,1), 1);
        end
        
        function outputs = ProcessForward(~, module, inputs)
            
            ics = module.ica.ics;
            pcs = module.pca;
            mu = pcs.mu;
            coeff = pcs.coeff';
            
            a = (inputs - repmat(mu, size(inputs,1), 1)) * pinv(coeff);
            
            outputs = a * pinv(ics);
        end
       
        function sim = GetCentroidsDistance(ia, module, gain, points)
            centroids = module.centroids;
            
            count_centroids = size(centroids, 1);
            count_points = size(points, 1);
            
            
            meand = module.centroids_mean_distance;
            
            dists = pdist(cat(1, points, centroids), 'euclidean');
            
            dists = dists(1:count_centroids * count_points);

            dists = reshape(dists, count_centroids, count_points)';

            c = max([meand; 10^-2*ones(size(meand))], [], 1);
            
            c = repmat(c, count_points, 1);
            
            b = 1./(2*gain*c.^2);
            
            sim = exp(-b/gain .* (dists.^2));

        end
        
        function [centroid, centroid_index, dist] = FindNearestCentroid(ia, module, point)
            centroids = module.centroids;
            dd = ia.GetCentroidsDistance(centroids, ia.gain, point);
            
            dist = min(dd);
            
            centroid_index = find(dd == dist);
            centroid_index = centroid_index(1);
            
            centroid = centroids(centroid_index, :);
            
            centroid_index = find(centroid_index);
        end
        
        function index = NextIndex(ia, nodeType)
            while ia.CountNodes() >= ia.MaxSize()
                ia.DoubleSize();
            end
            
            index = ia.CountNodes() + 1;
            ia.next_index = ia.next_index + 1;
            
            ia.modules_type(index) = nodeType;
        end
        
        function index = NewContextModule(ia, source_module_index)
            
            index = ia.NextIndex(ia.TYPE_CONTEXT);
            
            input_size = ia.GetModuleInputSize(source_module_index);
            output_size = ia.GetModuleOutputSize(source_module_index);
            module = [];
            
            module.source = source_module_index;
            module.input = zeros(input_size,1);
            module.output = zeros(output_size, 1);
            module.receptors = ia.context.NextAvailableIndeces( output_size )';
            module.activation = 0;
            
            module.cache_size = 1000;
            module.cache_count = 0;
            module.cache = zeros(module.cache_size, output_size);
            
            ia.modules{index} = module;
            
        end
        
        function DoubleSize(ia)
            ia.context.DoubleSize();
            
            curr_size = length(ia.modules);
            new_size = 2 * curr_size;
            increase = new_size - curr_size;
            
            ia.modules = cat(1, ia.modules, cell(increase,1));
            
            
            old_connections = ia.connections;
            ia.connections = zeros(new_size, new_size);
            ia.connections(1:curr_size, 1:curr_size) = old_connections;
            
            ia.modules_type = cat(1, ia.modules_type, zeros(increase,1));
            
            ia.graphs = cat(1, ia.graphs, cell(increase,1));
        end
        
    end
end

