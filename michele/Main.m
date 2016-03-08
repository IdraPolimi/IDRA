function ia = Main()

    ia = IntentionalArchitecture(3, 128);
    
    input = ia.NewInputNode();
    input1 = ia.NewInputNode();
    
    
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
    
    
    PopulateIntentionalArchitecture(ia);
    
    s = input.GetInputSize();
    c = 0.5 * ones(s, 1);
    a = -1;
    b = 1;
    
    cc = find(sum(ia.im_connections, 2) > 0);
    cc1 = find(sum(ia.im_connections, 2) > 0);
    
    %cc = cat(2, cc,transpose(cc1));
    
    g = digraph(ia.im_connections(cc, cc));
    
    figure(1);
    p = plot(g);
    highlight(p, 1:length(cc));
   
    while 1
        r = (b-a).*rand(s,1) + a;
        c = c + r * 0.1;
        c = max(zeros(s,1), min(ones(s, 1),c));
        input.SetInput(c);
        
        input1.SetInput(ones(s,1) - c);
        
        ia.Update();
        
        
        activations = ia.im_activations(1:ia.CountNodes());
        
        for ii = 1:length(cc)
            pp = power(activations(cc(ii)), 16);
             highlight(p, ii, 'NodeColor', [1 - pp, pp, 0]);
        end
        
%         figure(2);
%         pcolor(transpose(ia.im_ca));
        
    	pause(0.05);
    end

end

function PopulateIntentionalArchitecture(ia)

    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
    ia.NewIntentionalModule(min(ia.CountNodes() - 1, ceil(rand(1,3) * (ia.CountNodes() - 1) + ia.CountNodes() / 4)));
end
