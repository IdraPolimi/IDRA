function [updatedCategories, ids, meand] = categorizeInput(data,k)
% categorizeInput: categorize the new input with respect to
% data
% size(data)
% numberOfCategories
[ids, updatedCategories, sumd, dist] = kmeans(data, k, 'EmptyAction','singleton', 'Distance', 'sqeuclidean', 'Onlinephase','on');



count = hist(ids,1:k) + 1;

meand = sqrt(sumd ./ count');

%-------------------
mm = min(dist,[],2);

dd = dist == repmat(mm,1,size(dist,2));

sumd = sum(sqrt(dist.*dd));

meand = (sumd ./ count)';

meand = max(meand, 10^-6);
end


