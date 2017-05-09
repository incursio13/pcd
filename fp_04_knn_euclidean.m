function output = fp_04_knn_euclidean(allDataTrainProperties, singleDataTesProperty, k)
% This function implements KNN using Euclidean distance.
% Parameter:
%   allDataTrainProperties => All properties from data train.
%   singleDataTestProperty => Single property of a data test.
%   k => Number of neighbors.
% Output:
%   output => K int indicating indices of selected neighbors.
    len = length(allDataTrainProperties);
    distance = [];
    
    for i=1:len
        sum = 0.0;
        
        for j=1:3
            tmp = power(singleDataTesProperty(j).Contrast-allDataTrainProperties{i}(j).Contrast, 2);
            sum = sum + tmp;

            tmp = power(singleDataTesProperty(j).Correlation-allDataTrainProperties{i}(j).Correlation, 2);
            sum = sum + tmp;

            tmp = power(singleDataTesProperty(j).Energy-allDataTrainProperties{i}(j).Energy, 2);
            sum = sum + tmp;

            tmp = power(singleDataTesProperty(j).Homogeneity-allDataTrainProperties{i}(j).Homogeneity, 2);
            sum = sum + tmp;
        end
        
        distance = [distance sqrt(sum)];
    end

    [dt, ix] = sort(distance);
    output = ix(:,1:k);
end