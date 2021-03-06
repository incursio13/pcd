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
            
        tmp = power(singleDataTesProperty-allDataTrainProperties{i},2);  
        sum_tmp = sum(tmp);
        distance = [distance sqrt(sum_tmp)];
    end

    [dt, ix] = sort(distance);
    output = ix(:,1:k);
%     output = distance;
end