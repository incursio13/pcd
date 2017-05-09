function output = fp_03_glcm(image)
% Description:
%   Generate GLCM properties of an RGB image.
% Parameter:
%   Image which feature is to be extracted.
% Output:
%   Contrast, Correlation, Energy, Homogeneity
%   of each RGB feature of the image.

    red = image(:,:,1);
    green = image(:,:,2);
    blue = image(:,:,3);

    red = graycoprops(red);
    green = graycoprops(green);
    blue = graycoprops(blue);

    output = [red, green, blue];
end