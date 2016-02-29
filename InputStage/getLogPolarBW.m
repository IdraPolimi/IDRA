function result = getLogPolarBW(data)
% getLogPolarBW: compute the logpolar transformation of the input data
%   Input: data, an RGB image
%   Output: the transformed image
dataBW = rgb2gray(data);

xCenter = round(size(dataBW,1)/2);
yCenter = round(size(dataBW,2)/2);

result = logsample(dataBW,10,xCenter,yCenter,xCenter,size(dataBW,2),size(dataBW,1));
result(xCenter,yCenter) = 1;

