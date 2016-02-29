function output = computeOutput(projectedInput, categories, maxNumberOfCluster)
% computeOutput: evaluate the current input with respect to stored
% categories
%   Input: the input, as column vector and the centroids, as matrix (each centroid is a column).
%   Output: a vector of distances in range [0 1] as column vector;

distance = zeros(size(categories,2),1);
for ii = 1:size(categories,2)
    distance(ii) = 1 - tanh(norm(projectedInput - categories(:,ii),2));
end
%add zeros to have a fixed output size.
%distance = [distance zeros(1,maxNumberOfCluster-size(categories,2))];
output = distance;
end


