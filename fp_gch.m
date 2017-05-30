function output = fp_gch(im)

im = double(im);
im = round(im*3/255);


Red = im(:,:,1);
Green = im(:,:,2);
Blue = im(:,:,3);

[n,m]=size(Red);

ca = [0,0,0,0,;0,0,0,0;0,0,0,0;0,0,0,0];
ca(:,:,2) = [0,0,0,0,;0,0,0,0;0,0,0,0;0,0,0,0];
ca(:,:,3) = [0,0,0,0,;0,0,0,0;0,0,0,0;0,0,0,0];
ca(:,:,4) = [0,0,0,0,;0,0,0,0;0,0,0,0;0,0,0,0];


for i=1:(n*m)
    ca(Blue(i)+1,Green(i)+1,Red(i)+1)=ca(Blue(i)+1,Green(i)+1,Red(i)+1)+1;
end

ca=reshape(ca,1,64);
% ca= ca./ sum(ca);

output = ca;
end