%输入数据和是否做降维，输出准确率、临时准确率，模型参数
%praOpt表示是否做参数优化，1表示做，0表示不做
clear;clc;
load data_STG.mat

a=data_STG(:,1);
%1,3,5,7 作为 1 类  ；2,4,6,8 作为2类
for i=1:768
    if  a(i,1)==1||a(i,1)==2||a(i,1)==3||a(i,1)==4
        a(i,1)=1;
    elseif   a(i,1)==5||a(i,1)==6||a(i,1)==7||a(i,1)==8
        a(i,1)=2;
    elseif   a(i,1)==9||a(i,1)==10||a(i,1)==11||a(i,1)==12
        a(i,1)=3;
    elseif   a(i,1)==13||a(i,1)==14||a(i,1)==15||a(i,1)==16
        a(i,1)=4;
    end 
end    
data_STG(:,1)=a;
temp_data = data_STG(1:768,:);
allData = randBeforeSVM(temp_data);

confmat=zeros(2,2);
acc = [ ];
        
for i = 1:2
    index = ones(768,1);
%     index(1 + (i - 1)) = 0;
    index((1:384) + 384 * (i-1)) = 0;
    trainIndex = index == 1;
    testIndex = index == 0;
    trainData = allData(trainIndex,:);
    testData = allData(testIndex,:);
    model = svmtrain(trainData(:,1),trainData(:,2:end), ' -q');
    [predictLabel,accuracy,xxx] = svmpredict(testData(:,1),testData(:,2:end),model,' -q' );
    disp(['====',num2str(accuracy(1)),'=====']);
    acc = [acc accuracy(1)];
%      for j=1:9
%          for k=1:9
%              if allData(i,1)==j&& predictLabel==k
%                 confmat(j,k)=confmat(j,k)+1;
%              end
%          end
%      end
end
accracy = mean(acc);

%====70.1389=====
%====65.9722=====   二分类的准确率
% %[X,~,~]=find(v1(1,:)>=accracy);
% %[x1,y1]=size(X);
% %pvalue1=y10;
% 
% r(1)=accracy;
% %r(2)=pvalue1;
% fid=fopen('HMTV51.txt','wt');
% %for i=1:2
%     fprintf(fid,'%4.4f\n',r(1));
%     
%  [m,n]=size(confmat);
%  for i=1:1:m
%     for j=1:1:n
%        if j==n
%          fprintf(fid,'%g\n',confmat(i,j));
%        else
%          fprintf(fid,'%g\t',confmat(i,j));
%        end
%     end
%  end
% %end
% fclose(fid);
       
       