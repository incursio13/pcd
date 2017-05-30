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
        distance = [distance sum(sum_tmp)];
    end

    [dt, ix] = sort(distance);
    output = ix(:,1:k);
%     output = distance;
end