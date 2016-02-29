function [output, rs] = intentionalArchitecture(inputSignals)
% intentionalArchitecture: make a single run of the intentional
% architecture: input filtering, IM activation, CM output computation, CM
% categorization.
%   Input: inputSignals: signals coming from sensors as structure composed
%   of sig (the signal itself) and filterName (the filter to be applied).
%   Output: the output of the IA (corresponding to the output of the IM) and
%   the relevantSignal

%filter all the incoming data
processedData = inputProcessingModule(inputSignals);
%distribute the input to phyologenetic module and IMs
phylogeneticSignal = phylogeneticModule(inputSignals);


%TODO
%here we have to prepare the input to the IM, especially if we have more
%than one input directed to a single IM



%make a run of the intentional module
[imOutput, relevantSignal] = intentionalModule(processedData, phylogeneticSignal);


output = imOutput;
rs = relevantSignal;

end