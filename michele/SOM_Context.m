classdef SOM_Context < handle
    properties 
        width
        height
        map
        count_receptors
        
        neighborhood_size
        
        current_activation
    end
    
    methods
        function ctx = SOM_Context(size, max_categories, neighborhood_size)
            ctx.width = size;
            ctx.height = size;
            ctx.neighborhood_size = neighborhood_size;
            
            ctx.count_receptors = 1;
            
            ctx.map = ones(ctx.width, ctx.height, max_categories) * 0.01;
            
            
            ctx.current_activation = zeros(1, max_categories);
        end
        
        function indeces = nextAvailableIndeces(ctx, amount)
           indeces = zeros(amount, 1);
           
           for ii = 1:amount
               indeces(ii) = ctx.count_receptors;
               ctx.count_receptors = ctx.count_receptors +1;
           end
           
           
        end
        
        function receptor = AddReceptor(ctx)
            
            receptor = SOM_Receptor(ctx, ctx.count_receptors);
            ctx.count_receptors = ctx.count_receptors +1;
        end
        
        function Update(ctx)
            ca = ctx.current_activation;
            
            dist = zeros(ctx.height, ctx.width);
            
            for ii = 1:ctx.height
               for jj = 1:ctx.width
                  al = cat(1, reshape(ctx.map(ii,jj,:), 1, size(ctx.map,3)), ca);
                  dist(ii,jj) = pdist(al,'euclidean');
               end
            end
            
            [r, c] = find(dist == min(dist(:)));
            
            r = r(1);
            c = c(1);
            
            % update neighbourhood
            nn = ctx.neighborhood_size;
            for ii = max(1, r - nn) : min(ctx.height, r + nn)
                for jj = max(1, c - nn) : min(ctx.width, c + nn)
                    currDist = sqrt(power(ii - r,2) + power(jj - c,2));
                    if currDist < nn
                        ctx.map(ii,jj,:) = ctx.UpdateNode(1 - (currDist/nn), reshape(ctx.map(ii,jj,:),1, size(ctx.map(ii,jj,:),3)), ca);
                    end
                    
                end
                
            end
            
%             figure(2);
%             dist = zeros(ctx.height, ctx.width);
%             dist(r,c) = 1;
%             pcolor(dist);
        end
        
        
        
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
        function activations = GetActivations(ctx, indeces)
            indeces = transpose(indeces);
            fields = ctx.map(:,:,indeces);
            s1 = size(indeces,1);
            s2 = size(indeces, 2);
            
            % activations = reshape(fields, ctx.width, ctx.height, s1, s2);
            
            
            activations = sum(fields); 
            activations = sum(activations);
            
            mm = max(activations);
            
            activations = power(activations ./ mm, 2);
            
            activations = transpose(reshape(activations, s1, s2));
            
            %activations = transpose(activations);
        end
        
        function SetActivations(ctx, indeces, values)
            ctx.current_activation(indeces) = values;
        end
    end
end
