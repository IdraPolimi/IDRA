function ia = Main()


% 
%     imgPath = '/home/michele/Development/IDRA/IDRA/data/imgDataset';
%     imagefiles = dir('/home/michele/Development/IDRA/IDRA/data/imgDataset/*.jpg');      
%     nfiles = length(imagefiles);    % Number of files found
%     for ii=1:200
%        currentfilename = imagefiles(ii).name;
%        currentimage = imread(currentfilename);
%        images(ii,:,:) = currentimage;
%     end
% 
% 
%     ss = size(images);
%     images = reshape(images, ss(1), ss(2)*ss(3));
% 
%     images = double(images);
%     [icasig, A, W] = ica(images, 16);


    CheckGPU();
    k = 2;
    ia = IntentionalArchitecture(k, 16, 8);
    ia.UseGPU = true;
    
    defaultFilter = @NoFilter;
    
    input = ia.NewFilterNode(defaultFilter);
    input1 = ia.NewFilterNode(defaultFilter);
    
    input.Test(zeros(input.InputSize() - 2, 1));
    
    ia.NewIntentionalModule([1 2]);
    ia.NewIntentionalModule([1 2]);
    ia.NewIntentionalModule([3 4]);
    ia.NewIntentionalModule(3);
    ia.NewIntentionalModule([5 6]);
    ia.NewIntentionalModule([3 5]);
    ia.NewIntentionalModule([2 5]);
    ia.NewIntentionalModule([1 7]);
    ia.NewIntentionalModule([8 9]);
    ia.NewIntentionalModule([7 11]);
    ia.NewIntentionalModule([9 10]);
    ia.NewIntentionalModule([10 2]);
    ia.NewIntentionalModule([11 3]);
    ia.NewIntentionalModule([4 12]);
    
    
    PopulateIntentionalArchitecture(ia, k);
    
    s = input.InputSize();
    c = 0.5 * ones(s, 1);
    a = -1;
    b = 1;
    
    cc = find(sum(ia.im_connections, 2) > 0);
    cc1 = find(sum(ia.im_connections, 1) > 0);
    
    cc = cat(1, cc,transpose(cc1));
    
    g = digraph(ia.im_connections(1:ia.CountNodes(), 1:ia.CountNodes()));
    
    figure(1);
    p = plot(g);
    highlight(p, 1:ia.CountNodes());
    
    figure(2);
    h = pcolor(power(ia.im_ca, 16));
   
    while 1
        r = (b-a).*rand(s,1) + a;
        c = c + r * 0.1;
        c = max(zeros(s,1), min(ones(s, 1),c));
        input.SetInput(c);
        
        input1.SetInput(ones(s,1) - c);
        
        ia.Update();
        
        
        activations = ia.im_activations(1:ia.CountNodes());
        
        for ii = 1:ia.CountNodes()
            pp = power(activations(ii), 16);
             highlight(p, ii, 'NodeColor', [1 - pp, pp, 0]);
        end
        
        h.CData = power(ia.im_ca, 16);
        refreshdata(h);
        
        
    
    	pause(0.05);
    end

end


function CheckGPU()
    global GPU_AVAILABLE;
    try
        gpuDevice();
        GPU_AVAILABLE = 1;
    catch
        GPU_AVAILABLE = 0;
    end
end


function PopulateIntentionalArchitecture(ia, k)

    for i = 1:5
    	ia.NewIntentionalModule([ceil(rand(1) * 2), max(1, min(ia.CountNodes() - 1, floor(rand(1,k -1) * (ia.CountNodes() - 1))))]);
    end
    
    for i = 1:25
        ia.NewIntentionalModule(max(1, min(ia.CountNodes() - 1, ceil(rand(1,k) * (ia.CountNodes() - 1)))));
    end
end
