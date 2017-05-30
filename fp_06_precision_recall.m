function [acc, precision, recall] = fp_06_confmatrix(count_train, classPrediction, classActual)
    len = length(classPrediction);
    
    tp = 0.0;
    fp = 0.0;
    for i=1:len
        if classPrediction(i) == classActual
            tp = tp + 1.0;
        else
            fp = fp + 1.0;
        end
    end
    acc = (tp+(count_train-tp-2*fp))/count_train;
%     recall = precision / double(classCount(classActual));
    precision = tp / double(len);
    recall = precision;
end