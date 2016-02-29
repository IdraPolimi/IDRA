function [ newWeights ] = hebbianLearning(pathSavedDoc, oldWeights, relevantS, catOutput, disc, thresholdFixingOntho)
%HEBBIANLEARNING [newWeights] -> prende in ingresso i vecchi pesi, il
%relevant e l'output del category che ha generato quel relevant e il
%fattore di discount.
%   Detailed explanation goes here

weightsArr = load(strcat(pathSavedDoc,'\weightsArrFull.txt'));

newWeightsTemp = zeros(size(oldWeights));
for i=1:length(weightsArr)
%     if (oldWeights(i) > thresholdFixingOntho)
%         newWeightsTemp(i) = 1.0;
%     else
        newWeightsTemp(i)= weightsArr(i)+disc *((relevantS * ...
            catOutput(i))-(weightsArr(i) * (catOutput(i))^2));
%     end
end

print2file(newWeightsTemp, pathSavedDoc, 'weightsArrFull', 'matrix');
maxi = max(newWeightsTemp);

for i=1:length(newWeightsTemp)
    
    if(newWeightsTemp(i) ~= 0)
        newWeightsTemp(i) = newWeightsTemp(i)/maxi;
    end
end

newWeights = newWeightsTemp;

%print2file(newWeights,'IMSdoc','weights', 'vector');
end



% newWeightsTemp = zeros(size(oldWeights));
% for i=1:length(oldWeights)
% %     if (oldWeights(i) > thresholdFixingOntho)
% %         newWeightsTemp(i) = 1.0;
% %     else
%         newWeightsTemp(i)= oldWeights(i)+disc *((relevantS * ...
%             catOutput(i))-(oldWeights(i) * (catOutput(i))^2));
% %     end
% end
% 
% maxi = max(newWeightsTemp);
% 
% for i=1:length(newWeightsTemp)
%     
%     if(newWeightsTemp(i) ~= 0)
%         newWeightsTemp(i) = newWeightsTemp(i)/maxi;
%     end
% end
% 
% newWeights = newWeightsTemp;
% %print2file(newWeights,'IMSdoc','weights', 'vector');
% end