function output = fp_01_segmentation(image)

    gambar_asli=image;
    image=(imfilter(image,fspecial('disk'))); %filtering
   
    image=rgb2hsv(image); %dirubah jadi hsv
    I1=image(:,:,2);   % change to hsv and select the channel with most clear contrast between object and shadow

    thresholded = I1 > 0.3; %% Threshold to isolate lungs
    thresholded = bwareaopen(thresholded,100);  % remove too small pixels
%     imshow(thresholded);
    
    thresholded = imfill(thresholded,'holes');
    maskedRGBImage = gambar_asli;
    
    maskedRGBImage(repmat(~thresholded,[1 1 3])) = 0; %merubah background putih jadi hitam

%     figure, imshow(maskedRGBImage);
    
    output = maskedRGBImage;


end