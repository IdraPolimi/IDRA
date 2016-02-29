function image = dummyRobot(originalImage,xResolution,yResolution)


originalImageWidth = size(originalImage,1);
originalImageHeight = size(originalImage,2);
x = randi([0 originalImageWidth - xResolution],1);
y = randi([0 originalImageHeight- yResolution],1);

image = originalImage(x+1:x+xResolution,y+1:y+yResolution,:);