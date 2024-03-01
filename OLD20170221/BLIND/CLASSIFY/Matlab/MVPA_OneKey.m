%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  MVPA 和使用 SVM 分类；可以同时跑多个被试的数据。
clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%
% 控制处理几个被试
filter = '20161006002*';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%路径信息
mvpa_path = 'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\';
mvpa_design = 'D:\FMRI_ROOT\YANTAI\DESIGN\';
pre_processing_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\';
mvpa_mask = 'D:\FMRI_ROOT\YANTAI\DESIGN\MASK';
mask_name = {'NiftiPairs_Resliced_STG.mn.img','mask.img'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. 加载需要的实验设计数据
cd(mvpa_design);
load('a.mat');% 标记空的TR
load('tutorial_runs');%标记每个TR属于哪个run
load label;%标记每一个非空的TR表示的类别，
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. 将w开头的预处理之后的图像拷贝到分类文件夹
cd(pre_processing_path);
subExpID = dir(filter);
for i=1:size(subExpID,1)
    cd([pre_processing_path,subExpID(i).name]);
    mkdir([mvpa_path,subExpID(i).name,'\funcImg\']);
    subRunID = dir('ep2d*');
    for j=1:size(subRunID,1)
        cd([pre_processing_path,subExpID(i).name,'\',subRunID(j).name]);
        copyfile('wraf*',[mvpa_path,subExpID(i).name,'\funcImg\'],'f');
    end   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. 读取功能像文件
for ids=1:size(subExpID,1)
    cd([mvpa_path,subExpID(ids).name,'\funcImg\']);
    filenames = dir('w*.img');
    raw_filenames=cell(1,1088); %一个被试总的w开头的文件数量===================================================================
    for j=1:size(filenames,1)
        raw_filenames{j} = filenames(j).name;
    end

    % MVPA
    for k=1:size(mask_name,2)
        % 初始化一个被试的结构体，两个参数都是自己确定的命名
        subj = init_subj('zjl',subExpID(ids).name);
        cd(mvpa_mask);
        subj = load_spm_mask(subj,[mask_name{k},'_category-selective'],mask_name{k});
        cd([mvpa_path,subExpID(ids).name,'\funcImg\']);
        subj = load_spm_pattern(subj,'epi',[mask_name{k},'_category-selective'],raw_filenames);
        subj = init_object(subj,'selector','runs');
        subj = set_mat(subj,'selector','runs',tutorial_runs);
        subj = zscore_runs(subj,'epi','runs');
        subj = create_xvalid_indices(subj,'runs');
        before_zscore_mat = get_mat(subj,'pattern','epi')';
        after_zscore_mat = get_mat(subj,'pattern','epi_z')';
        b=1:1088;%====================================================================================================================================
        after_zscore=[b' after_zscore_mat];
        %删掉空TR,根据矩阵a中的数据
        for ii=1088:-1:1
            for jj=1:320
               if ii==a(jj,1)
                  after_zscore(ii,:)=[];
               end
            end
        end
        data_STG_raw=after_zscore(:,2:end);

        data_STG=zeros(768,size(data_STG_raw,2)+1);
        data_STG(1:768,1)=label(1:768,1);
        data_STG(1:768,2:end)=data_STG_raw(1:768,1:end);
        cd([mvpa_path,subExpID(ids).name]);
        save(['data_',mask_name{k},'.mat'],'data_STG');
        clear subj;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    data_path = [mvpa_path,subExpID(ids).name];
    cd(data_path);
    diary class_result.txt;
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
        confmat=zeros(2,2);
        acc = [ ];
        disp([mask_name{k},':四分类==================']);
        for i = 1:2
            index = ones(768,1);
            index((1:384) + 384 * (i-1)) = 0;
            trainIndex = index == 1;
            testIndex = index == 0;
            trainData = allData(trainIndex,:);
            testData = allData(testIndex,:);
            model = svmtrain(trainData(:,1),trainData(:,2:end), ' -q');
            [predictLabel,accuracy,xxx] = svmpredict(testData(:,1),testData(:,2:end),model,' -q' );
            disp(['====',num2str(accuracy(1)),'=====']);
        end
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
        confmat=zeros(2,2);
        acc = [ ];
        disp([mask_name{k},':方位分类==================']);
        for i = 1:2
            index = ones(768,1);
            index((1:384) + 384 * (i-1)) = 0;
            trainIndex = index == 1;
            testIndex = index == 0;
            trainData = allData(trainIndex,:);
            testData = allData(testIndex,:);
            model = svmtrain(trainData(:,1),trainData(:,2:end), ' -q');
            [predictLabel,accuracy,xxx] = svmpredict(testData(:,1),testData(:,2:end),model,' -q' );
            disp(['====',num2str(accuracy(1)),'=====']);
        end
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
        confmat=zeros(2,2);
        acc = [ ];
        disp([mask_name{k},':噪声分类==================']);
        for i = 1:2
            index = ones(768,1);
            index((1:384) + 384 * (i-1)) = 0;
            trainIndex = index == 1;
            testIndex = index == 0;
            trainData = allData(trainIndex,:);
            testData = allData(testIndex,:);
            model = svmtrain(trainData(:,1),trainData(:,2:end), ' -q');
            [predictLabel,accuracy,xxx] = svmpredict(testData(:,1),testData(:,2:end),model,' -q' );
            disp(['====',num2str(accuracy(1)),'=====']);
        end
        %--------------------------------------------------------------------------------
    end
    toc
    diary off ;
end
