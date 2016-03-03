function [categoryOutput relevantSignal] = intentionalModule(filteredInput, phylogSignal)
% intentionalModule

%%
phyloThreshold = 0.3;
distanceThreshold = 0.3;
maxNumberOfCluster = 10;
load('IDRA/data/ics.mat');
load('IDRA/data/data.mat');
load('IDRA/data/categories.mat');


%%
tempInput.sig = [filteredInput(1).sig ; filteredInput(2).sig];
    
projectedInput = projectInput(tempInput.sig, ics);
disp(['Phylosig: ', num2str(phylogSignal)]);
categoryOutput = computeOutput(projectedInput, categories, maxNumberOfCluster);

numberOfCategories = length(categoryOutput)
if(phylogSignal > phyloThreshold)
    data = [data projectedInput];
    
    if (numberOfCategories == 0)
        disp('Create first category!');
        numberOfCategories = numberOfCategories + 1;
    elseif (max(categoryOutput) <= distanceThreshold && length(categoryOutput) < maxNumberOfCluster)
        disp('Adding new category!');
        numberOfCategories = numberOfCategories + 1;
    else
        disp('No new category!');
    end
    categories = categorizeInput(data,numberOfCategories);

end
save('data/categories.mat','categories');
save('data/data.mat','data');

relevantSignal = phylogSignal;

end




