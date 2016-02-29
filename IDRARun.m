function [output rs] = IDRARun(signals)

% data = zeros(0);
% categories = zeros(0);
% save('data/categories.mat','categories');
% save('data/data.mat','data');


for ii=1:2000
    dummyImg = dummyRobot(img, 200,300);
    figure(1)
    imshow(dummyImg);
    %signals(1).sig = visione;
    %signals(1).filterName = 'LogPolarBW';
    %signals(1).instinct = 'None';
    %signals(2).sig = visione;
    %signals(2).filterName = 'None';
    %signals(2).instinct = 'ballPosition';
    %signals(3).sig = proprio;
    %signals(3).filterName = 'None';
    %signals(3).instinct = 'None';
    %[output, rs] = intentionalArchitecture(signals);
    disp('==========================================');
    pause
end
