function ia = Main()
    close all;

%     ia = IntentionalArchitecture(k, 8, 4, 80);
    ia = IA(0.33, 1.5);
%     pfc = PFCModule(ia);
    ia.UseGPU = true;
    
    defaultFilter = @NoFilter;
%     icaFilter = @(img) img * pinv(icasig);
    
    input1 = ia.NewFilterNode(32, defaultFilter);
%     input2 = ia.NewFilterNode(16, defaultFilter);
    
    
    tset = 512;
    nc = 8;
    
    k = 1;
%     PopulateIntentionalArchitecture(ia, k, tset, nc);

    im1 = ia.NewIntentionalModule(input1.index, tset, nc); 
    im2 = ia.NewIntentionalModule(input1.index, tset, nc); 
    im3 = ia.NewIntentionalModule(input1.index, tset, nc); 
    im4 = ia.NewIntentionalModule(input1.index, tset, nc); 
    
    im21 = ia.NewIntentionalModule([im1 im2 im3 im4], tset, nc); 
    im22 = ia.NewIntentionalModule([im1 im2 im3 im4], tset, nc);
    
    im31 = ia.NewIntentionalModule([im21 im22], tset, nc); 
    im32 = ia.NewIntentionalModule([im21 im22], tset, nc);
    
    im41 = ia.NewIntentionalModule([im31 im32], tset, nc); 
    im42 = ia.NewIntentionalModule([im31 im32], tset, nc);
    
    im51 = ia.NewIntentionalModule([im41 im42], tset, nc); 
    im52 = ia.NewIntentionalModule([im41 im42], tset, nc);
    
    im61 = ia.NewIntentionalModule([im51 im52], tset, nc); 
    im62 = ia.NewIntentionalModule([im51 im52], tset, nc);
    
    im71 = ia.NewIntentionalModule([im61 im62], tset, nc); 
    im72 = ia.NewIntentionalModule([im61 im62], tset, nc);
    
    im81 = ia.NewIntentionalModule([im71 im72], tset, nc); 
    im82 = ia.NewIntentionalModule([im71 im72], tset, nc);
    
    im91 = ia.NewIntentionalModule([im81 im82], tset, nc); 
    im92 = ia.NewIntentionalModule([im81 im82], tset, nc);
    
    im101 = ia.NewIntentionalModule([im91 im92], tset, nc); 
    im102 = ia.NewIntentionalModule([im91 im92], tset, nc);
    
    imf1 = ia.NewIntentionalModule([im101 im102], tset, nc); 
    imf2 = ia.NewIntentionalModule([im101 im102], tset, nc); 
    
    
    
    
    s = input1.InputSize();
    c = 0.5 * ones(s, 1);
    a = -1;
    b = 1;
    
    
    
    figure(1068);
    steps = 2000;
    hold on;
    erp = plot(1:steps, zeros(1, steps), 'G');
    rp = plot(1:steps, zeros(1, steps), 'R');
    deltap = plot(1:steps, zeros(1, steps), 'B');
    activep = plot(1:steps, zeros(1,steps), 'Y');
    
    hold off;
    
    figure(6789);
    in_plot = plot(zeros(1,s));
    
    figure(6790);
    hold on;
    out_plot1 = plot(zeros(1,steps));
    out_plot2 = plot(zeros(1,steps));
    axis([0 steps -1 1]);
    hold off;
    x = 1;
    
    noise = 10;
    
    l1 = 2;
    l2 = 3;
    
    output = 0;
    
    while 1
        x
        r = (b-a).*rand(2,s) + a;
        nn = pi * (-1 +2* rand());
        htset = tset /2;
        
        if ~any(ia.IsBootstraping([imf1 imf2]))
            reward = -abs(sum(in));
            ia.modules{imf1}.reward = reward;
            ia.modules{imf2}.reward = reward;
        end
        
        mm = (mod(x,htset)/htset - output ) * ones(1,s);
        nn = pi * 2;%(1 + 2*rand());
        in = mm(1)*exp(linspace(0,nn,s))+noise*rand(1,s);
        

        input1.SetInput(in);
        
        
        ia.Update();
        
        out1 = sum(ia.GetModuleOutput(imf1));
        out2 = sum(ia.GetModuleOutput(imf2));
        
        output = 0.8*output + 0.2*mean([out1 out2]);
        
        in_plot.YData = in;
        
        rp.YData(1:end-1) = rp.YData(2:end);
        rp.YData(end) = sum(ia.GetModuleReward(1:ia.CountNodes()));
        
        erp.YData(1:end-1) = erp.YData(2:end); 
        erp.YData(end) = mean(rp.YData(end-500:end));
%         
        out_plot1.YData(1:end-1) = out_plot1.YData(2:end); 
        out_plot1.YData(end) =  output;
        
        out_plot2.YData(1:end-1) = out_plot2.YData(2:end); 
        out_plot2.YData(end) = -output;
        
        pause(0.001);
        x = x+1;
    end

end



function PopulateIntentionalArchitecture(ia, k, training_set_size, n_out)

    for i = 1:5
        ceil(rand(1,k) * ia.CountNodes())
        ceil(rand(1) * 8)
    	ia.NewIntentionalModule([ceil(rand(1) * 2), max(1, min(ia.CountNodes() - 1, floor(rand(1,k -1) * (ia.CountNodes() - 1))))], training_set_size, n_out);
    end
    
    for i = 1:15
        ia.NewIntentionalModule(ceil(rand(1,k) * ia.CountNodes()), training_set_size, n_out);
    end
end
