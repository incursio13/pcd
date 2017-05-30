function [classCount, classIdentity, classImage, imageDir, imageName] = fp_02_load(path)
% Description:
%   Load all possible files based on path.
% Parameter:
%   Path is supposed to be the folder where all dataset reside.
% Output:
%   classCount => Define the number of image for each class.
%   classIdentity => Define class identity for each data.
%   classImage => Contains all image loaded as defined by classCount.
%   imageDir => Directory or path where each image is located.
%   imageName => Name of each image loaded.

    dataDir = dir(path);

    classCount = [];
    classIdentity = [];
    classImage = {};
    imageDir = {};
    imageName = {};

    dirnum = 0;
    for i=1:length(dataDir)
        if length(dataDir(i).name) > 2
            ctr = 0;
            dfiles = strcat(path, dataDir(i).name);

            ifiles = dir(dfiles);
            for j=1:32
                if ifiles(j).isdir == 0
                    ctr = ctr + 1;
                    
                    imdir = strcat(dfiles, '\',ifiles(j).name);
                    imageDir = [imageDir imdir];
                    imageName = [imageName ifiles(j).name];

                    img = imread(imdir);
%                     img = imresize(img,[500 500]);
                    classImage = [classImage img];

                    classIdentity = [classIdentity i-dirnum];
                end
            end
            
            classCount = [classCount ctr];
        else
            dirnum = dirnum + 1;
        end
    end
end
