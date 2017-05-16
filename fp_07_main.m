clear;
clc;

path = 'dataset/';
numOfTrain = 0.8;
k = 5;

% ===========================================================================

% Load images.
[classCount, classIdentity, classImage, imageDir, imageName] = fp_02_load(path);
% 
% Image segmentation.
temp = {};
for i=1:length(classImage)
    temp = [temp fp_01_segmentation(classImage{i})];
end

segmentImage = temp;

% ===========================================================================

% Get glcm properties.
glcmClassProperties = {};
glcmSegmentProperties = {};
for i=1:length(classImage)
    glcmClassProperties = [glcmClassProperties fp_03_glcm(classImage{i})];
    
    glcmSegmentProperties = [glcmSegmentProperties fp_03_glcm(segmentImage{i})];

end

% ===========================================================================

% Separate data train and data test.
[dtrainIdentity, dtestIdentity] = fp_05_separate(classCount, classIdentity, numOfTrain);

[dtrainClassImage, dtestClassImage] = fp_05_separate(classCount, classImage, numOfTrain);
[dtrainSegmentImage, dtestSegmentImage] = fp_05_separate(classCount, segmentImage, numOfTrain);

[dtrainName, dtestName] = fp_05_separate(classCount, imageName, numOfTrain);
[dtrainDir, dtestDir] = fp_05_separate(classCount, imageDir, numOfTrain);

[dtrainClassGLCM, dtestClassGLCM] = fp_05_separate(classCount, glcmClassProperties, numOfTrain);
[dtrainSegmentGLCM, dtestSegmentGLCM] = fp_05_separate(classCount, glcmSegmentProperties, numOfTrain);

% ===========================================================================

% Trivia
temp = dtrainIdentity;
dtrainIdentity = [];
for i=1:length(temp)
    idx_class_can_pixel = temp{i};
    for j=1:length(idx_class_can_pixel)
        dtrainIdentity = [dtrainIdentity idx_class_can_pixel(j)];
    end
end

temp = dtestIdentity;
dtestIdentity = [];
for i=1:length(temp)
    idx_class_can_pixel = temp{i};
    for j=1:length(idx_class_can_pixel)
        dtestIdentity = [dtestIdentity idx_class_can_pixel(j)];
    end
end

clear classIdentity;
clear classImage;
clear imageName;
clear imageDir;
clear classProperties;
clear sv;
% % ===========================================================================
% 
% KNN retrieval.

% GLCM
idx_class_can_GLCM = {};
idx_class_euc_GLCM = {};
    
idx_segment_can_GLCM = {};
idx_segment_euc_GLCM = {};

pr_class_can_GLCM = {};
pr_class_euc_GLCM = {};
    
pr_segment_can_GLCM = {};
pr_segment_euc_GLCM = {};
% 
for i=1:length(dtestClassGLCM)
    % ========================= GLCM ======================
    % Class - Canberra - Pixel
    temp = fp_04_knn_canberra(dtrainClassGLCM, dtestClassGLCM{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_class_can_GLCM = [idx_class_can_GLCM temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_class_can_GLCM = [pr_class_can_GLCM temp];
    
    % Class - Euclidean - GLCM
    temp = fp_04_knn_euclidean(dtrainClassGLCM, dtestClassGLCM{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_class_euc_GLCM= [idx_class_euc_GLCM temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_class_euc_GLCM = [pr_class_euc_GLCM temp];
    
    % Segment - Canberra - GLCM
    temp = fp_04_knn_canberra(dtrainSegmentGLCM, dtestSegmentGLCM{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_segment_can_GLCM = [idx_segment_can_GLCM temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_segment_can_GLCM = [pr_segment_can_GLCM temp];
    
    % Segment - Euclidean - GLCM
    temp = fp_04_knn_euclidean(dtrainSegmentGLCM, dtestSegmentGLCM{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_segment_euc_GLCM = [idx_segment_euc_GLCM temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_segment_euc_GLCM = [pr_segment_euc_GLCM temp];
end
% 
% ====================== Average ===============
avg_class_can_GLCM = 0.0;
avg_class_euc_GLCM = 0.0;
avg_segment_can_GLCM = 0.0;
avg_segment_euc_GLCM = 0.0;
% 
for i=1:length(dtestDir)
    avg_class_can_GLCM = avg_class_can_GLCM + pr_class_can_GLCM{i}(1);
    avg_class_euc_GLCM = avg_class_euc_GLCM + pr_class_euc_GLCM{i}(1);
    
    avg_segment_can_GLCM = avg_segment_can_GLCM + pr_segment_can_GLCM{i}(1);
    avg_segment_euc_GLCM = avg_segment_euc_GLCM + pr_segment_euc_GLCM{i}(1);
end
% 
avg_class_can_GLCM = avg_class_can_GLCM / double(length(dtestDir));
avg_class_euc_GLCM = avg_class_euc_GLCM / double(length(dtestDir));

avg_segment_can_GLCM = avg_segment_can_GLCM / double(length(dtestDir));
avg_segment_euc_GLCM = avg_segment_euc_GLCM / double(length(dtestDir));

% ================ Trivia ==============
% clear i; clear j; clear prec; clear rec; clear temp;
% clear clsPrediction;
% 
% % Done.