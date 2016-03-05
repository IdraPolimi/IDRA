function ia = Main()

    ia = IntentionalArchitecture(20, 2);
    
    input = ia.NewInputNode();
    input1 = ia.NewInputNode();
    
    ia.NewIntentionalModule(2);
    ia.NewIntentionalModule([2 3]);
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
    
    s = input.GetInputSize();
    c = 0.5 * ones(s, 1);
    a = -1;
    b = 1;
    
    g = digraph(ia.im_connections);
    figure(1);
    p = plot(g);
    
    activations = ia.im_activations(1:ia.CountNodes());
    highlight(p, 1:length(activations));
    
    while 1
        r = (b-a).*rand(s,1) + a;
        c = c + r * 0.05;
        c = max(zeros(s,1), min(ones(s, 1),c));
        input.SetInput(c);
        
        input1.SetInput(ones(s,1) - c);
        
        ia.Update();
        
        
        activations = ia.im_activations(1:ia.CountNodes());
        
        for ii = 1:length(activations)
            pp = power(activations(ii), 2);
             highlight(p, ii, 'NodeColor', [1 - pp, pp, 0]);
        end
        
        figure(2);
        
        pcolor(transpose(ia.im_ca));
        
    	pause(0.05);
    end

end

