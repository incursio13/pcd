function [precision, recall] = fp_06_confmatrix(classCount, classPrediction, classActual)
    len = length(classPrediction);
    
    precision = 0.0;
    for i=1:len
        if classPrediction(i) == classActual
            precision = precision + 1.0;
        end
    end
    
%     recall = precision / double(classCount(classActual));
    precision = precision / double(len);
    recall = precision;
end