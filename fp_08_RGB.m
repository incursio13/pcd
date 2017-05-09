function output = fp_08_RGB(image)

    RGB_image=image;
    s=struct('Contrast',{},'Correlation',{},'Energy',{},'Homogeneity',{});
    for k=1:3
        contrast=0;
        homogenity=0;
        energy=0;
        correlation=0;
        RGB_image=double(RGB_image);
        stdc=std(RGB_image(:,:,k));
        stdr=std(RGB_image(:,:,k),0,2);
        m_c=mean(RGB_image(:,:,k));
        m_r=mean(RGB_image(:,:,k),2);
        % x=medfilt2(R1);
        % R = corr2(R1,x);
        for i=1:128
            for j=1:128
                contrast=contrast+((i-j)^2*RGB_image(i,j,k));
                homogenity=homogenity+RGB_image(i,j,k)/(1+abs(i-j));
                energy=energy+RGB_image(i,j,k)^2;
                correlation=correlation+(i-m_r(i))*(j-m_c(j))*RGB_image(i,j,k)/(stdc*stdr);
            end
        end

        s(1,k).Contrast=contrast;
	    s(1,k).Correlation=correlation;
		s(1,k).Energy=energy;
        s(1,k).Homogeneity=homogenity;

    end
    output = s;
end