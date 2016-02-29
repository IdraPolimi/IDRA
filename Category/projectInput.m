function inputProjected = projectInput(input, ics)
% projectInput: take the row input as column vector and the independent
% component and project the first on the second.
%   Input: the data as column vector, the ics as matrix
%   Output: the data projected onto the ics.

%remove the mean from input
inputMean = mean(input);
input = input - inputMean;
size(input)
%project the input onto the ics
projected = ics * input;

% make unitary norm
norma = norm(projected,2);
inputProjected = projected./norma;
