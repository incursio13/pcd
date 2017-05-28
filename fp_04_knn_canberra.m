function output = fp_04_knn_canberra(allDataTrainProperties, singleDataTesProperty, k)
% This function implements KNN using Canberra distance.
% Parameter:
%   allDataTrainProperties => All properties from data train.
%   singleDataTestProperty => Single property of a data test.
%   k => Number of neighbors.
% Output:
%   output => K int indicating indices of selected neighbors.
    len = length(allDataTrainProperties);
    distance = [];
    
    for i=1:len
        tmp = abs(singleDataTesProperty-allDataTrainProperties{i});
        sum_tmp = tmp./(abs(singleDataTesProperty)+abs(allDataTrainProperties{i}));
        sum_tmp(isnan(sum_tmp))=0;
%         for j=1:3
%             tmp = abs(singleDataTesProperty(j).Contrast-allDataTrainProperties{i}(j).Contrast);
%             sum = sum + tmp/(abs(singleDataTesProperty(j).Contrast)+abs(allDataTrainProperties{i}(j).Contrast));
% 
%             tmp = abs(singleDataTesProperty(j).Correlation-allDataTrainProperties{i}(j).Correlation);
%             sum = sum + tmp/(abs(singleDataTesProperty(j).Correlation)+abs(allDataTrainProperties{i}(j).Correlation));
% 
%             tmp = abs(singleDataTesProperty(j).Energy-allDataTrainProperties{i}(j).Energy);
%             sum = sum + tmp/(abs(singleDataTesProperty(j).Energy)+abs(allDataTrainProperties{i}(j).Energy));
% 
%             tmp = abs(singleDataTesProperty(j).Homogeneity-allDataTrainProperties{i}(j).Homogeneity);
%             sum = sum + tmp/(abs(singleDataTesProperty(j).Homogeneity)+abs(allDataTrainProperties{i}(j).Homogeneity));
%         end
        
        distance = [distance sum(sum_tmp)];
    end

    [dt, ix] = sort(distance);
    output = ix(:,1:k);
%     output = distance;
end