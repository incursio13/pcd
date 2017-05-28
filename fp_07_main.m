clear;
clc;

path = 'dataset/';
numOfTrain = 0.8;

% ===========================================================================

% Load images.
[classCount, classIdentity, classImage, imageDir, imageName] = fp_02_load(path);
k = int8((1-numOfTrain)*classCount(1));

% Image segmentation.
% temp = {};
% for i=1:length(classImage)
%     temp1 = fp_01_segmentation(classImage{i});
%     temp = [temp temp1];
% end

% % for i=1:length(temp)
% %    figure, imshow(temp{i}); 
% % end

% % segmentImage = temp;

% ===========================================================================

% Get global color histogram.
gch = {};
for i=1:length(classImage)
    gch_temp = fp_gch(classImage{i});
    gch = [gch gch_temp];
end

% ===========================================================================

% Separate data train and data test.
[dtrainIdentity, dtestIdentity] = fp_05_separate(classCount, classIdentity, numOfTrain);

% [dtrainClassImage, dtestClassImage] = fp_05_separate(classCount, classImage, numOfTrain);
% [dtrainSegmentImage, dtestSegmentImage] = fp_05_separate(classCount, segmentImage, numOfTrain);

[dtrainName, dtestName] = fp_05_separate(classCount, imageName, numOfTrain);
[dtrainDir, dtestDir] = fp_05_separate(classCount, imageDir, numOfTrain);

[dtrainClassGCH, dtestClassGCH] = fp_05_separate(classCount, gch, numOfTrain);
% [dtrainSegmentGCH, dtestSegmentGCH] = fp_05_separate(classCount, glcmSegmentProperties, numOfTrain);

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
% 
% KNN retrieval.
% GCH

idx_can_GCH = {};
idx_euc_GCH = {};
    
% idx_segment_can_GCH = {};
% idx_segment_euc_GCH = {};

pr_can_GCH = {};
pr_euc_GCH = {};
    
% pr_segment_can_GCH = {};
% pr_segment_euc_GCH = {};
% 
for i=1:length(dtestClassGCH)
    % ========================= GCH ======================
    % Canberra - GCH - No Segment
    temp = fp_04_knn_canberra(dtrainClassGCH, dtestClassGCH{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_can_GCH = [idx_can_GCH temp];
    [acc, prec, rec] = fp_06_precision_recall(length(dtrainIdentity),classCount, clsPrediction, dtestIdentity(i));
    temp = [acc, prec, rec];
    pr_can_GCH = [pr_can_GCH temp];
    
    % Euclidean - GCH - No Segment
    temp = fp_04_knn_euclidean(dtrainClassGCH, dtestClassGCH{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_euc_GCH= [idx_euc_GCH temp];
    [acc, prec, rec] = fp_06_precision_recall(length(dtrainIdentity),classCount, clsPrediction, dtestIdentity(i));
    temp = [acc, prec, rec];
    pr_euc_GCH = [pr_euc_GCH temp];
    
%     % Segment - Canberra - GCH
%     temp = fp_04_knn_canberra(dtrainSegmentGCH , dtestSegmentGCH{i}, k);
%     
%     clsPrediction = [];
%     for j=1:length(temp)
%         clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
%     end
%     
%     idx_segment_can_GCH = [idx_segment_can_GCH temp];
%     [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
%     temp = [prec, rec];
%     pr_segment_can_GCH = [pr_segment_can_GCH temp];
%     
% %     Segment - Euclidean - GCH 
%     temp = fp_04_knn_euclidean(dtrainSegmentGCH, dtestSegmentGCH{i}, k);
%     
%     clsPrediction = [];
%     for j=1:length(temp)
%         clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
%     end
%     
%     idx_segment_euc_GCH = [idx_segment_euc_GCH temp];
%     [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
%     temp = [prec, rec];
%     pr_segment_euc_GCH = [pr_segment_euc_GCH temp];
end

% % ====================== Average ===============
avg_acc_can = 0.0;
avg_acc_euc = 0.0;
avg_can_GCH = 0.0;
avg_euc_GCH = 0.0;
% avg_segment_can_GCH = 0.0;
% avg_segment_euc_GCH = 0.0;
% % 
for i=1:length(dtestDir)
    avg_acc_can = avg_acc_can + pr_can_GCH{i}(1);
    avg_acc_euc = avg_acc_euc + pr_euc_GCH{i}(1);
    avg_can_GCH = avg_can_GCH + pr_can_GCH{i}(2);
    avg_euc_GCH = avg_euc_GCH + pr_euc_GCH{i}(2);
    
%     avg_segment_can_GCH = avg_segment_can_GCH + pr_segment_can_GCH{i}(1);
%     avg_segment_euc_GCH = avg_segment_euc_GCH + pr_segment_euc_GCH{i}(1);
end
% 
avg_acc_euc = avg_acc_euc / double(length(dtestDir));
avg_acc_can = avg_acc_can / double(length(dtestDir));
avg_can_GCH = avg_can_GCH / double(length(dtestDir));
avg_euc_GCH = avg_euc_GCH / double(length(dtestDir));

% avg_segment_can_GCH = avg_segment_can_GCH / double(length(dtestDir));
% avg_segment_euc_GCH = avg_segment_euc_GCH / double(length(dtestDir));

% ================ Trivia ==============
% clear i; clear j; clear prec; clear rec; clear temp;
% clear clsPrediction;
% 
% % Done.