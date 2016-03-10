classdef SOM_Context < handle
    properties 
        map
        count_receptors
        
        neighborhood_size
        
        current_activation
        
        LastHit
        UseGPU
    end
    
    methods
        function ctx = SOM_Context(size, max_categories, neighborhood_size)
            ctx.neighborhood_size = neighborhood_size;
            
            ctx.count_receptors = 1;
            
            ctx.map = ones(size, size, max_categories);
            
            
            ctx.current_activation = zeros(1, max_categories);
            ctx.LastHit = zeros(1, 2);
            
            ctx.UseGPU = 0;
        end
        
        function DoubleSize(ctx)
            
            [width, height] = ctx.SOM_Width_Height();
            
            curr_size = length(ctx.current_activation);
            new_size = 2 * curr_size;
            inc_size = new_size - curr_size;
            
            ctx.current_activation = cat(2, ctx.current_activation, zeros(1, inc_size));
            
            
            curr_map_size = length(ctx.map);
            new_map_size = 2 * curr_size;
            inc_map_size = new_map_size - curr_map_size;
            
            ctx.map = cat(3, ctx.map, zeros(height, width, inc_map_size));
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
            
            [width, height] = ctx.SOM_Width_Height();
            useGPU = ctx.UseGPU();
            
            ca = ctx.current_activation(1,:);
            dist = zeros(height, width);
            mm = ctx.map;
            
            if useGPU
                ca = gpuArray(ca);
                dist = gpuArray(dist);
                mm = gpuArray(mm);
            end
            
            ca = repmat(ca, [height, 1, width]);
            ca = permute(ca, [1 3 2]);
            
            
            bb = mm - ca;
            
            bb = power(bb,2);
            
            dist = sqrt(sum(bb, 3));
            
            
            [r, c] = find(dist == min(dist(:)));
            
            
            
            if useGPU
                ca = gather(ca);
                dist = gather(dist);
                mm = gather(mm);
                r = gather(r);
                c = gather(c);
            end
            
            
            r = r(1);
            c = c(1);
            
            % update neighbourhood
            nn = ctx.neighborhood_size;
            mask = zeros(height, width);
            
            
            
            
            for ii = max(1, r - nn) : min(height, r + nn)
                for jj = max(1, c - nn) : min(width, c + nn)
                    currDist = sqrt(power(ii - r,2) + power(jj - c,2));
                    if currDist < nn
                        ctx.map(ii,jj,:) = ctx.UpdateNode(1 - (currDist/nn), reshape(ctx.map(ii,jj,:),1, size(ctx.map(ii,jj,:),3)), reshape(ca(ii,jj,:),1, size(ctx.map(ii,jj,:),3)));
                    end
                end
            end
            
            ctx.LastHit = [r, c];
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
        
        function res = MaxReceptors(ctx)
            res = size(ctx.map, 3);
        end
    end
    
    methods 
        
        function [w, h] = SOM_Width_Height(ctx)
            [h, w, ~] = size(ctx.map);
        end
        
        function res = get.UseGPU(ctx)
        	res = ctx.UseGPU;
        end
        
        function set.UseGPU(ctx, val)
        	try
                gpuDevice;
            	ctx.UseGPU = val ~= 0;
            catch
                ctx.UseGPU = false;
        	end
        end
    end
    
    methods (Access = public)
        
        function activations = GetActivations(ctx, indeces)
            indeces = transpose(indeces);
            fields = ctx.map(:,:,indeces);
            s1 = size(indeces,1);
            s2 = size(indeces, 2);
            
            
            activations = sum(fields); 
            activations = sum(activations);
            
            mm = max(activations);
            
            activations = power(activations ./ mm, 2);
            
            activations = transpose(reshape(activations, s1, s2));
            
        end
        
        function SetActivations(ctx, indeces, values)
            ctx.current_activation(indeces) = values;
        end
    end
end
