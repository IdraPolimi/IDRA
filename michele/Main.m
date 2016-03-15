function ia = Main()



% 
%     imagefiles = dir('/home/michele/Development/IDRA/IDRA/michele/imgs/*.jpg');      
%     nfiles = length(imagefiles);    % Number of files found
%     for ii=1:nfiles
%        currentfilename = imagefiles(ii).name;
%        currentimage = imread(currentfilename);
%        images(ii,:,:,:) = currentimage;
%     end
% 
%     lh = size(images,2);
%     lw = size(images,3);
%     images = images(:, lh *0.4: lh*0.6, lw*0.4:lw*0.6,:);
% 
%     ss = size(images);
%     img1 = reshape(images(1,:,:,:), 1, ss(2)*ss(3)*ss(4));
%     img2 = reshape(images(2,:,:,:), 1, ss(2)*ss(3)*ss(4));

    k = 2;
    ia = IntentionalArchitecture(k, 8, 4, 512);
    ia.UseGPU = true;
    
    defaultFilter = @NoFilter;
    
    input = ia.NewFilterNode(defaultFilter);
    input1 = ia.NewFilterNode(defaultFilter);
    
    
    ia.NewIntentionalModule([2 3]); % 4 5
    ia.NewIntentionalModule([2 3]); % 6 7
    ia.NewIntentionalModule([2 4]); % 8 9
    ia.NewIntentionalModule([2 8]); % 10 11
    ia.NewIntentionalModule([8 10]); % 12 13
    ia.NewIntentionalModule([3 6]); % 14 16
    ia.NewIntentionalModule([3 14]); % 16 17
    ia.NewIntentionalModule([14 16]); % 18 19
    ia.NewIntentionalModule([18 12]); % 20 21
    
    
    %PopulateIntentionalArchitecture(ia, k);
    
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
    h = pcolor(ia.im_ca);
    caxis([0 1]);
    x = 0;
    
    
    while 1
        x
        r = (b-a).*rand(2,s) + a;
        if x < 200
            in(1,:) = ones(1,s) * sin(x);
            in(2,:) = ones(1,s) * sin(x);
        else
            if x >= 200 && x <300
                in(1,:) = ones(1,s) * cos(x);
                in(2,:) = ones(1,s) * cos(x);
            else
                in(1,:) = ones(1,s);
                in(2,:) = ones(1,s);
            end
        end
        in = in + r * 0.1;
        x = x+0.2;
        
        input.SetInput(in(1,:));
        
        input1.SetInput(in(2,:));
        
        ia.Update();
        
        
        activations = ia.GetNodesActivation(1:ia.CountNodes());
        
        for ii = 1:ia.CountNodes()
            pp = activations(ii);
             highlight(p, ii, 'NodeColor', [1 - pp, pp, 0]);
        end
        
        h.CData = ia.im_ca;
        refreshdata(h);
        
        figure(3);
        mesh(ia.context.map(:,:,1));
        axis([0 20 0 20 0 1]);
        caxis([0 1]);
        
        pause(0.05);
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
