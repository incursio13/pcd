function output = fp_01_segmentation(image)
    %H = padarray(2,[2 2]) - fspecial('gaussian' ,[5 5],2);
    %image=imfilter(image,H);
    gambar_asli=image;
    image=(imfilter(image,fspecial('disk'))); %filtering
   
    image=rgb2hsv(image); %dirubah jadi hsv
    I1=image(:,:,2);   % change to hsv and select the channel with most clear contrast between object and shadow

    thresholded = I1 > 0.18; %% Threshold to isolate lungs
    thresholded = bwareaopen(thresholded,100);  % remove too small pixels
    %I2=thresholded.*I1;
    %I3=edge(I2,'canny',graythresh(I2));  % ostu method
    %I3 = imfill(I3,'hole');
    %figure,imshow(I3) ; %object binary image

    maskedRGBImage = gambar_asli;

    maskedRGBImage(repmat(~thresholded,[1 1 3])) = 0; %merubah background putih jadi hitam

%     figure, imshow(maskedRGBImage);
    output = maskedRGBImage;
end