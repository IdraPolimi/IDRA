function result = getCartesianSaturation(data)
% getCartesianSaturation: compute the hsv transformation of the input data
%   Input: data, an RGB image
%   Output: the transformed image

result = rgb2hsv(data);
result = result(:,:,2);
