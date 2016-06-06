close all

    imgs = zeros(1,600,800);
	imgs(1,:,:) = double(star);
    
    
    in_size = size(imgs);
    img_size = [in_size(end-1), in_size(end)];
    
    n_patch = 5000;
    patch_base_size = 25;
    
    
    patch_size = ceil(repmat([patch_base_size, patch_base_size], n_patch,1) );%+ repmat(10 * rand(n_patch,1) - 5, 1, 2));
    
    patch_pos = floor([img_size(1) * rand(n_patch,1), img_size(2) * rand(n_patch,1) + 1]);
    
    
    m1 = patch_size(:,1) / 2;
    m2 = patch_size(:,2) / 2;
    
    
    patch_pos(:,1) = max(patch_pos(:,1), ceil(m1) + 1);
    patch_pos(:,1) = min(patch_pos(:,1), img_size(1) - ceil(m1));
    
    patch_pos(:,2) = max(patch_pos(:,2), ceil(m2) + 1);
    patch_pos(:,2) = min(patch_pos(:,2), img_size(2) - ceil(m2));
    
    
    min_w = min(patch_size(:,1));
    min_h = min(patch_size(:,2));
    
    norm_patches = zeros(in_size(1)*n_patch, min_w, min_h);
    
    
    
    for jj = 1:in_size(1)
        img = reshape(imgs(jj,:,:), in_size(2), in_size(3));
        jj
        for ii = 1:n_patch
            m1 = patch_size(ii,1) / 2;
            m2 = patch_size(ii,2) / 2;
            
            patch = img(patch_pos(ii,1) - floor(m1):patch_pos(ii,1) + floor(m1), patch_pos(ii,2) - floor(m2):patch_pos(ii,2) + floor(m2));
            patch = imresize(patch,[min_w, min_h]);
            
            patch = patch - mean(mean(patch));
            
            
            
            norm_patches( (jj - 1) * n_patch + ii, :, :) = patch;
        end
    end
    
    norm_patches = reshape(norm_patches, size(norm_patches,1), size(norm_patches,2) * size(norm_patches,3));
    
    [coeff,score,latent] = pca(norm_patches);
    
    
    k = 1;
    currk = latent(1);
    sumk = sum(latent);
    
    while currk / sumk < 0.98
        k = k + 1;
        currk = currk + latent(k);
        
    end
    
    reduced_dim_patches = score(:,1:k)*coeff(:,1:k)';
    
    [updatedCategories, ids, meand] = categorizeInput(reduced_dim_patches,100);
