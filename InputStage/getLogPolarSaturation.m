function result = getLogPolarSaturation(data)
% getLogPolarSaturation: compute the saturation of the logpolar transformation of the input data
%   Input: data, an RGB image
%   Output: the transformed image

xCenter = round(size(data,1)/2);
yCenter = round(size(data,2)/2);

result = logsample(data,10,xCenter,yCenter,xCenter,size(data,2),size(data,1));
figure(10)
imshow(result);
result = rgb2hsv(result);
result = result(:,:,2);

