img = imread('/data/img.jpg','jpg');
img = double(img./255);

data = zeros(0);
categories = zeros(0);
save('data/categories.mat','categories');
save('data/data.mat','data');


for ii=1:2000
    dummyImg = dummyRobot(img, 200,300);
    figure(1)
    imshow(dummyImg);
    signals(1).sig = dummyImg;
    signals(1).filterName = 'LogPolarBW';
    signals(1).instinct = 'None';
    signals(2).sig = dummyImg;
    signals(2).filterName = 'LogPolarSaturation';
    signals(2).instinct = 'HighSaturated';
    [output, rs] = intentionalArchitecture(signals);
    disp('==========================================');
    pause
end
