function ia = Main()

<<<<<<< HEAD
    ia = IntentionalArchitecture(3, 128);
=======
    ia = IntentionalArchitecture(20, 2);
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
    
    input = ia.NewInputNode();
    input1 = ia.NewInputNode();
    
<<<<<<< HEAD
    
    ia.NewIntentionalModule([1 2]);
    ia.NewIntentionalModule([1 2]);
=======
    ia.NewIntentionalModule(2);
    ia.NewIntentionalModule([2 3]);
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
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
    
<<<<<<< HEAD
    
    PopulateIntentionalArchitecture(ia);
    
=======
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
    s = input.GetInputSize();
    c = 0.5 * ones(s, 1);
    a = -1;
    b = 1;
    
<<<<<<< HEAD
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
=======
    g = digraph(ia.im_connections);
    figure(1);
    p = plot(g);
    
    activations = ia.im_activations(1:ia.CountNodes());
    highlight(p, 1:length(activations));
    
    while 1
        r = (b-a).*rand(s,1) + a;
        c = c + r * 0.05;
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
        c = max(zeros(s,1), min(ones(s, 1),c));
        input.SetInput(c);
        
        input1.SetInput(ones(s,1) - c);
        
        ia.Update();
        
        
        activations = ia.im_activations(1:ia.CountNodes());
        
<<<<<<< HEAD
        for ii = 1:length(cc)
            pp = power(activations(cc(ii)), 16);
             highlight(p, ii, 'NodeColor', [1 - pp, pp, 0]);
        end
        
%         figure(2);
%         pcolor(transpose(ia.im_ca));
=======
        for ii = 1:length(activations)
            pp = power(activations(ii), 2);
             highlight(p, ii, 'NodeColor', [1 - pp, pp, 0]);
        end
        
        figure(2);
        
        pcolor(transpose(ia.im_ca));
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
        
    	pause(0.05);
    end

end

<<<<<<< HEAD
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
=======
>>>>>>> b6b88a938b717ed156d1a581c61c16e3996b96db
