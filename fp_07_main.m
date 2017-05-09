path = 'C:\Users\Arhy\Documents\viskom.fp\dataset\fixed\';
numOfTrain = 0.8;
k = 5;

% ===========================================================================

% Load images.
[classCount, classIdentity, classImage, imageDir, imageName] = fp_02_load(path);

% Image segmentation.
temp = {};
for i=1:length(classImage)
    temp = [temp fp_01_segmentation(classImage{i})];
end

segmentImage = temp;

% ===========================================================================

% Pixel properties.
pixelClassProperties = cell(1,length(classCount));
pixelSegmentProperties = cell(1,length(classCount));

% Get glcm properties.
glcmClassProperties = {};
glcmSegmentProperties = {};
for i=1:length(classImage)
    glcmClassProperties = [glcmClassProperties fp_03_glcm(classImage{i})];
    pixelClassProperties{i} = fp_08_RGB(classImage{i});
    
    glcmSegmentProperties = [glcmSegmentProperties fp_03_glcm(segmentImage{i})];
    pixelSegmentProperties{i} = fp_08_RGB(segmentImage{i});
end

% ===========================================================================

% Separate data train and data test.
[dtrainIdentity, dtestIdentity] = fp_05_separate(classCount, classIdentity, numOfTrain);

[dtrainClassImage, dtestClassImage] = fp_05_separate(classCount, classImage, numOfTrain);
[dtrainSegmentImage, dtestSegmentImage] = fp_05_separate(classCount, segmentImage, numOfTrain);

[dtrainName, dtestName] = fp_05_separate(classCount, imageName, numOfTrain);
[dtrainDir, dtestDir] = fp_05_separate(classCount, imageDir, numOfTrain);

[dtrainClassGLCM, dtestClassGLCM] = fp_05_separate(classCount, glcmClassProperties, numOfTrain);
[dtrainClassPixel, dtestClassPixel] = fp_05_separate(classCount, pixelClassProperties, numOfTrain);

[dtrainSegmentGLCM, dtestSegmentGLCM] = fp_05_separate(classCount, glcmSegmentProperties, numOfTrain);
[dtrainSegmentPixel, dtestSegmentPixel] = fp_05_separate(classCount, pixelSegmentProperties, numOfTrain);

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
% ===========================================================================

% KNN retrieval.
% Pixel
idx_class_can_pixel = {};
idx_class_euc_pixel = {};
    
idx_segment_can_pixel = {};
idx_segment_euc_pixel = {};

pr_class_can_pixel = {};
pr_class_euc_pixel = {};
    
pr_segment_can_pixel = {};
pr_segment_euc_pixel = {};

% GLCM
idx_class_can_GLCM = {};
idx_class_euc_GLCM = {};
    
idx_segment_can_GLCM = {};
idx_segment_euc_GLCM = {};

pr_class_can_GLCM = {};
pr_class_euc_GLCM = {};
    
pr_segment_can_GLCM = {};
pr_segment_euc_GLCM = {};

for i=1:length(dtestClassPixel)
    % ========================= Pixel ======================
    % Class - Canberra - Pixel
    temp = fp_04_knn_canberra(dtrainClassPixel, dtestClassPixel{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_class_can_pixel = [idx_class_can_pixel temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_class_can_pixel = [pr_class_can_pixel temp];
    
    % Class - Euclidean - Pixel
    temp = fp_04_knn_euclidean(dtrainClassPixel, dtestClassPixel{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_class_euc_pixel= [idx_class_euc_pixel temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_class_euc_pixel = [pr_class_euc_pixel temp];
    
    % Segment - Canberra - Pixel
    temp = fp_04_knn_canberra(dtrainSegmentPixel, dtestSegmentPixel{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_segment_can_pixel = [idx_segment_can_pixel temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_segment_can_pixel = [pr_segment_can_pixel temp];
    
    % Segment - Euclidean - Pixel
    temp = fp_04_knn_euclidean(dtrainSegmentPixel, dtestSegmentPixel{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_segment_euc_pixel= [idx_segment_euc_pixel temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_segment_euc_pixel = [pr_segment_euc_pixel temp];
    
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

% ====================== Average ===============
avg_class_can_Pixel = 0.0;
avg_class_can_GLCM = 0.0;
avg_class_euc_Pixel = 0.0;
avg_class_euc_GLCM = 0.0;
avg_segment_can_Pixel = 0.0;
avg_segment_can_GLCM = 0.0;
avg_segment_euc_Pixel = 0.0;
avg_segment_euc_GLCM = 0.0;

for i=1:length(dtestDir)
    avg_class_can_Pixel = avg_class_can_Pixel + pr_class_can_pixel{i}(1);
    avg_class_can_GLCM = avg_class_can_GLCM + pr_class_can_GLCM{i}(1);
    avg_class_euc_Pixel = avg_class_euc_Pixel + pr_class_euc_pixel{i}(1);
    avg_class_euc_GLCM = avg_class_euc_GLCM + pr_class_euc_GLCM{i}(1);
    
    avg_segment_can_Pixel = avg_segment_can_Pixel + pr_segment_can_pixel{i}(1);
    avg_segment_can_GLCM = avg_segment_can_GLCM + pr_segment_can_GLCM{i}(1);
    avg_segment_euc_Pixel = avg_segment_euc_Pixel + pr_segment_euc_pixel{i}(1);
    avg_segment_euc_GLCM = avg_segment_euc_GLCM + pr_segment_euc_GLCM{i}(1);
end

avg_class_can_Pixel = avg_class_can_Pixel / double(length(dtestDir));
avg_class_can_GLCM = avg_class_can_GLCM / double(length(dtestDir));
avg_class_euc_Pixel = avg_class_euc_Pixel / double(length(dtestDir));
avg_class_euc_GLCM = avg_class_euc_GLCM / double(length(dtestDir));

avg_segment_can_Pixel = avg_segment_can_Pixel / double(length(dtestDir));
avg_segment_can_GLCM = avg_segment_can_GLCM / double(length(dtestDir));
avg_segment_euc_Pixel = avg_segment_euc_Pixel / double(length(dtestDir));
avg_segment_euc_GLCM = avg_segment_euc_GLCM / double(length(dtestDir));

% ================ Trivia ==============
clear i; clear j; clear prec; clear rec; clear temp;
clear clsPrediction;

% Done.