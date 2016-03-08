classdef SOM_Context < handle
    properties 
        width
        height
        map
        count_receptors
        
        neighborhood_size
        
        current_activation
        
        last_hit
    end
    
    methods
        function ctx = SOM_Context(size, max_categories, neighborhood_size)
            ctx.width = size;
            ctx.height = size;
            ctx.neighborhood_size = neighborhood_size;
            
            ctx.count_receptors = 1;
            
            ctx.map = ones(ctx.width, ctx.height, max_categories) * 0.01;
            
            
            ctx.current_activation = zeros(1, max_categories);
            last_hit = zeros(1, 2);
        end
        
<<<<<<< HEAD
        function DoubleSize(ctx)
            
            curr_size = length(ctx.current_activation);
            new_size = 2 * curr_size;
            inc_size = new_size - curr_size;
            
            ctx.current_activation = cat(2, ctx.current_activation, zeros(1, inc_size));
=======
        function indeces = nextAvailableIndeces(ctx, amount)
           indeces = zeros(amount, 1);
           
           for ii = 1:amount
               indeces(ii) = ctx.count_receptors;
               ctx.count_receptors = ctx.count_receptors +1;
           end
           
           
        end
        
        function receptor = AddReceptor(ctx)
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
            
            
            curr_map_size = length(ctx.map);
            new_map_size = 2 * curr_size;
            inc_map_size = new_map_size - curr_map_size;
            
            ctx.map = cat(3, ctx.map, rand(ctx.width, ctx.height, inc_map_size));
        end
        
        function indeces = NextAvailableIndeces(ctx, amount)
           indeces = zeros(amount, 1);
           for ii = 1:amount
               indeces(ii) = ctx.count_receptors;
               ctx.count_receptors = ctx.count_receptors +1;
           end
           
           
        end
        
        function receptor = AddReceptor(ctx)
            while ctx.CountReceptors() >= ctx.MaxReceptors();
                ctx.DoubleSize();
            end
            index = ctx.NextAvailableIndeces(1);
            receptor = SOM_Receptor(ctx, index);
        end
        
        function Update(ctx)
            ca = gpuArray(ctx.current_activation(1,:));
            ca = repmat(ca, [ctx.width, 1, ctx.height]);
            
            ca = permute(ca, [1 3 2]);
            
            dist = zeros(ctx.height, ctx.width);
            dist = gpuArray(dist);
            
<<<<<<< HEAD
            al = ctx.map;
            al = gpuArray(al);
=======
            for ii = 1:ctx.height
               for jj = 1:ctx.width
                  al = cat(1, reshape(ctx.map(ii,jj,:), 1, size(ctx.map,3)), ca);
                  dist(ii,jj) = pdist(al,'euclidean');
               end
            end
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
            
            
<<<<<<< HEAD
            bb = al - ca;
            
            bb = power(bb,2);
            
            dist = sqrt(sum(bb, 3));
            
            dist = gather(dist);
            ca = gather(ca);
            
            [r, c] = find(dist == min(dist(:)));
            
=======
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
            r = r(1);
            c = c(1);
            
            % update neighbourhood
            nn = ctx.neighborhood_size;
           
            
            for ii = max(1, r - nn) : min(ctx.height, r + nn)
                for jj = max(1, c - nn) : min(ctx.width, c + nn)
                    currDist = sqrt(power(ii - r,2) + power(jj - c,2));
                    if currDist < nn
<<<<<<< HEAD
                        ctx.map(ii,jj,:) = ctx.UpdateNode(1 - (currDist/nn), reshape(ctx.map(ii,jj,:),1, size(ctx.map(ii,jj,:),3)), reshape(ca(ii,jj,:),1, size(ctx.map(ii,jj,:),3)));
=======
                        ctx.map(ii,jj,:) = ctx.UpdateNode(1 - (currDist/nn), reshape(ctx.map(ii,jj,:),1, size(ctx.map(ii,jj,:),3)), ca);
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
                    end
                    
                end
                
            end
            
<<<<<<< HEAD
=======
%             figure(2);
%             dist = zeros(ctx.height, ctx.width);
%             dist(r,c) = 1;
%             pcolor(dist);
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
        end
        
        function res = UpdateNode(~, weight, old, new)
            a = weight;
            a = sqrt(a);
            res = 0;
            try
                res = (1-a) .* old + a * new;
            catch e
                tt = 1;
            end
                
        end
        
        function res = CountReceptors(ctx)
            res = ctx.count_receptors;
        end
        
<<<<<<< HEAD
        function res = MaxReceptors(ctx)
            res = size(ctx.map, 3);
        end
    end
    
    methods (Access = public)
=======
        function res = UpdateNode(~, weight, old, new)
            a = weight;
            try
                res = (1-a) .* old + a * new;
            catch e
                tt = 1;
            end
                
        end
        
        function plot(ctx, index)
           surf(ctx.map(:,:,index)); 
        end
    end
    
    methods 
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
        function activations = GetActivations(ctx, indeces)
            indeces = transpose(indeces);
            fields = ctx.map(:,:,indeces);
            s1 = size(indeces,1);
            s2 = size(indeces, 2);
            
<<<<<<< HEAD
=======
            % activations = reshape(fields, ctx.width, ctx.height, s1, s2);
            
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
            
            activations = sum(fields); 
            activations = sum(activations);
            
            mm = max(activations);
            
            activations = power(activations ./ mm, 2);
            
            activations = transpose(reshape(activations, s1, s2));
            
<<<<<<< HEAD
=======
            %activations = transpose(activations);
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
        end
        
        function SetActivations(ctx, indeces, values)
            ctx.current_activation(indeces) = values;
        end
    end
end
