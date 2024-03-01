function svms(filter)
clc;
%%%%%%%%%%%%%%%%%%%%%%
% 控制处理几个被试
%filter = '2016*';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%路径信息
mvpa_path = 'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\';
mvpa_design = 'D:\FMRI_ROOT\YANTAI\DESIGN\';
pre_processing_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\';
mvpa_mask = 'D:\FMRI_ROOT\YANTAI\DESIGN\MASK';
mask_name = {'second_level_s8_4class_TL.img'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(mvpa_path);
subExpID=dir(filter);%=======================================

for  ids=1:size(subExpID,1)
    data_path = [mvpa_path,subExpID(ids).name];
    cd(data_path);
    if exist('second_level_s8_4class_TL_class_result.txt','file')
        delete 'second_level_s8_4class_TL_class_result.txt';
    end
    diary second_level_s8_4class_TL_class_result.txt;
    tic;
    for k=1:size(mask_name,2)
        data_file = ['data_',mask_name{k},'.mat'];
        load(data_file);
        %---------------------------------------------
        a=data_STG(:,1); %四分类
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
        acc = cell(2,1);
        for i = 1:2
            index = ones(768,1);
            index((1:384) + 384 * (i-1)) = 0;
            trainIndex = index == 1;
            testIndex = index == 0;
            trainData = allData(trainIndex,:);
            testData = allData(testIndex,:);
            model = svmtrain(trainData(:,1),trainData(:,2:end), ' -q');
            [predictLabel,accuracy,xxx] = svmpredict(testData(:,1),testData(:,2:end),model,' -q' );
            acc{i} = accuracy(1);
            disp( num2str( accuracy(1) ) );
        end
        disp(num2str( (acc{1} + acc{2})/2.0 ));
    %------------------------------------------------------
        b=data_STG(:,1); %二分类，方位
        for i=1:768
            if  b(i,1)==1||b(i,1)==2||b(i,1)==5||b(i,1)==6||b(i,1)==9||b(i,1)==10||b(i,1)==13||b(i,1)==14
                b(i,1)=1;
            elseif   b(i,1)==3||b(i,1)==4||b(i,1)==7||b(i,1)==8||b(i,1)==11||b(i,1)==12||b(i,1)==15||b(i,1)==16
                b(i,1)=2;
            end 
        end
    
        data_STG(:,1)=b;
        temp_data = data_STG(1:768,:);
        allData = randBeforeSVM(temp_data);
        acc = cell(2,1);
        for i = 1:2
            index = ones(768,1);
            index((1:384) + 384 * (i-1)) = 0;
            trainIndex = index == 1;
            testIndex = index == 0;
            trainData = allData(trainIndex,:);
            testData = allData(testIndex,:);
            model = svmtrain(trainData(:,1),trainData(:,2:end), ' -q');
            [predictLabel,accuracy,xxx] = svmpredict(testData(:,1),testData(:,2:end),model,' -q' );
            acc{i} = accuracy(1);
            disp( num2str( accuracy(1) ) );
        end
        disp(num2str( (acc{1} + acc{2})/2.0 ));
    %---------------------------------------------------------
        c=data_STG(:,1); %二分类，噪音
        for i=1:768
            if  c(i,1)==1||c(i,1)==3||c(i,1)==5||c(i,1)==7||c(i,1)==9||c(i,1)==11||c(i,1)==13||c(i,1)==15
                c(i,1)=1;
            elseif   c(i,1)==2||c(i,1)==4||c(i,1)==6||c(i,1)==8||c(i,1)==10||c(i,1)==12||c(i,1)==14||c(i,1)==16
                c(i,1)=2;
            end 
        end
    
        data_STG(:,1)=a;
        temp_data = data_STG(1:768,:);
        allData = randBeforeSVM(temp_data);
        acc = cell(2,1);
        for i = 1:2
            index = ones(768,1);
            index((1:384) + 384 * (i-1)) = 0;
            trainIndex = index == 1;
            testIndex = index == 0;
            trainData = allData(trainIndex,:);
            testData = allData(testIndex,:);
            model = svmtrain(trainData(:,1),trainData(:,2:end), ' -q');
            [predictLabel,accuracy,xxx] = svmpredict(testData(:,1),testData(:,2:end),model,' -q' );
            acc{i} = accuracy(1);
            disp( num2str( accuracy(1) ) );
        end
        disp(num2str( (acc{1} + acc{2})/2.0 ));
        %--------------------------------------------------------------------------------
    end
    toc;
    diary off ;
end