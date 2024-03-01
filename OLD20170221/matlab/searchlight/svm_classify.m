function [accracy] = svm_classify(dataTest,label)
data=[label dataTest];
acc = [ ];      
for i = 1:4
    index = ones(768,1);
    index((1:192) + 192*(i-1)) = 0;
    trainIndex = index == 1;
    testIndex = index == 0;
    trainData = data(trainIndex,:);
    testData = data(testIndex,:);
    model = svmtrain(trainData(:,1),trainData(:,2:end), ' -q');
    [predictLabel,accuracy,xxx] = svmpredict(testData(:,1),testData(:,2:end),model,' -q' );
 %%   disp(['====',num2str(accuracy(1)),'=====']);%%%
    acc = [acc accuracy(1)];
end
accracy = mean(acc);

    
    
       
       
   