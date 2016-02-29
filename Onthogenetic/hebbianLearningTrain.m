function [ newWeights ] = hebbianLearningTrain( oldWeights, relevantS, catOutput, disc, thresholdFixingOntho)
%HEBBIANLEARNING [newWeights] -> prende in ingresso i vecchi pesi, il
%relevant e l'output del category che ha generato quel relevant e il
%fattore di discount.
%   Detailed explanation goes here

newWeightsTemp = zeros(size(oldWeights));
for i=1:length(oldWeights)
%     if (oldWeights(i) > thresholdFixingOntho)
%         newWeightsTemp(i) = 1.0;
%     else
        newWeightsTemp(i)= oldWeights(i)+disc *((relevantS * catOutput(i))-(oldWeights(i) * (catOutput(i))^2));

%     end
end
newWeights = newWeightsTemp;
print2file(newWeights,'IMSdoc','weights', 'vector');
end