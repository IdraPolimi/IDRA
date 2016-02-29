function phyloSignal = phylogeneticModule(signals)
% phylogeneticModule: 
%   Input: structure of signals coming from sensors; the structure must
%   have two fields, sig (the signal itself as column vector) )and type
%   (the filter it comes fromas string)
%   Output: a scalar value in range [0 1] 

phyloSignals = [];

for ii = 1: length(signals)
    switch signals(ii).instinct
        case 'LowSaturated' %To be implemented
            value = 0;
            phyloSignals = [phyloSignals value];
            
        case 'MidSaturated' %To be implemented
            value = 0;
            phyloSignals = [phyloSignals value];
        case 'HighSaturated' %To be implemented
            signals(ii).sig(1:40)
            value = sum(signals(ii).sig)/length(signals(ii).sig);
            phyloSignals = [phyloSignals value];
        case 'None' 
            value = 0;
            phyloSignals = [phyloSignals value];
        case 'ballPosition'
            
            [centers, radii] = imfindcircles(signals(ii).sig,[10 35],'ObjectPolarity','bright', 'Sensitivity',0.9);
            if (isempty(centers))
                value=0;
            else
                value=1-norm(centers-[120 0],2)/200;
            end
            %chiamare trova la pallina...
            phyloSignals = [phyloSignals value];
        otherwise 
            disp('Warning: you have specified an unexpected instinct!');
            disp('         No instinct will be used!');
            value = 0;
            phyloSignals = [phyloSignals value];
    end
end
phyloSignal = max(phyloSignals);
end