function [dataTrain, dataTest] = fp_05_separate(classCount, dataSet, numOfDataTrain)
    len = length(classCount);
    
    dataTrain = {};
    dataTest = {};
    start = 0;
    for i=1:len
        lg = int32(classCount(i)*numOfDataTrain);
        
        if i > 1
            start = sum(classCount(:,1:i-1));
        end
        
        tmp = dataSet(:,start+1:start+lg);
        dataTrain = [dataTrain tmp];
        
        tmp = dataSet(:,start+lg+1:start+classCount(i));
        dataTest = [dataTest tmp];
    end
end