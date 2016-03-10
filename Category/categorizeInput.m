function updatedCategories = categorizeInput(data,numberOfCategories)
% categorizeInput: categorize the new input with respect to
% data
% size(data)
% numberOfCategories
[~, updatedCategories] = kmeans(data', numberOfCategories, 'EmptyAction','singleton', 'Onlinephase','on');
updatedCategories = updatedCategories';


end

