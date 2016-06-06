function imgs = acquire_images(cam, n)


rgbImage = snapshot(cam);
grayImage = rgb2gray(rgbImage);
 
is = size(rgbImage);

imgs = zeros(n, is(1) * is(2));


for ii =1:n
    rgbImage = snapshot(cam);
    grayImage = rgb2gray(rgbImage);
    imgs(ii,:) = reshape(grayImage,1, is(1)*is(2));
    pause(1);
end

end