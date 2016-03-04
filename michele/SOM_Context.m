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
            
            ctx.map = rand(ctx.width, ctx.height, max_categories);
            
            
            ctx.current_activation = zeros(1, max_categories);
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
                  dist(ii,jj) = pdist(cat(1, reshape(ctx.map(ii,jj,:), 1, size(ctx.map,3)), ca),'euclidean');
               end
            end
            
            [r, c] = find(dist == min(dist(:)));
            
            
            
            % update neighbourhood
            nn = ctx.neighborhood_size;
            for ii = max(1, r - nn) : min(ctx.height, r + nn)
                for jj = max(1, c - nn) : min(ctx.width, c + nn)
                    currDist = sqrt(power(ii - r,2) + power(jj - c,2));
                    if currDist < nn
                        ctx.map(ii,jj,:) = ctx.UpdateNode(reshape(ctx.map(ii,jj,:),1, size(ctx.map(ii,jj,:),3)), ca);
                    end
                    
                end
                
            end
            
            
        end
        
        
        
        function res = UpdateNode(~, old, new)
            a = 0.9;
            res = (1-a) .* old + a * new;
        end
    end
    
    methods 
        function R_SetActivation(ctx, index, val)
            ctx.current_activation(index) = val;
        end
        
        function activation = R_GetActivation(ctx, index)
           activation = sum(sum(ctx.map(:,:,index))) / (ctx.width * ctx.height); 
        end
    end
end
