clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%文件的总数
raw_filenames=cell(1,1088);
mvpa_path = 'D:\data_processing\jianlong\data_processing\mvpa\20160716002\';
mvpa_design = 'D:\data_processing\jianlong\data_processing\mvpa\design\';
mask_name = 'WholeBrainMask.img';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


cd(mvpa_design);
load('a.mat');% 标记空的TR
% 初始化一个被试的结构体，两个参数都是自己确定的命名
subj = init_subj('zjl','subj002');

%STG.img是自己制作的mask
subj = load_spm_mask(subj,'STG_category-selective',mask_name);

cd([mvpa_path,'funcImg']);
filenames = dir('w*.img');
for i=1:size(filenames,1)
    raw_filenames{i} = filenames(i).name;
end
    
subj = load_spm_pattern(subj,'epi','STG_category-selective',raw_filenames);

% initialize the regressors object in the subj structure, load in the
% contents from a file, set the contents into the object and add a
% cell array of condnames to the object for future reference
% subj = init_object(subj,'regressors','conds');
% load('tutorial_regs');
% 
% subj = set_mat(subj,'regressors','conds',tutorial_regs);
% condnames = {'left','right'};
% subj = set_objfield(subj,'regressors','conds','condnames',condnames);

% store the names of the regressor conditions
% initialize the selectors object, then read in the contents
% for it from a file, and set them into the object
subj = init_object(subj,'selector','runs');
cd(mvpa_design);
load('tutorial_runs');%标记每个TR属于哪个run
subj = set_mat(subj,'selector','runs',tutorial_runs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRE-PROCESSING - z-scoring in time and no-peeking anova

% we want to z-score the EPI data (called 'epi'),
% individually on each run (using the 'runs' selectors)
subj = zscore_runs(subj,'epi','runs');

% now, create selector indices for the n different iterations of
% the nminusone
subj = create_xvalid_indices(subj,'runs');
before_zscore_mat = get_mat(subj,'pattern','epi')';
after_zscore_mat = get_mat(subj,'pattern','epi_z')';
b=1:1088;
after_zscore=[b' after_zscore_mat];

%删掉空TR,根据矩阵a中的数据
for i=1088:-1:1
    for j=1:320
       if i==a(j,1)
          after_zscore(i,:)=[];
       end
    end
end

data_STG_raw=after_zscore(:,2:end);
load label;%标记每一个非空的TR表示的类别，
data_STG=zeros(768,size(data_STG_raw,2)+1);
data_STG(1:768,1)=label(1:768,1);
data_STG(1:768,2:end)=data_STG_raw(1:768,1:end);
cd(mvpa_path);
save(['data_',mask_name,'.mat'],'data_STG');


a=data_STG(:,1);

%1，2，3，4 -----1
%5，6，7，8 -----2
%9，10，11，12 ----3
%13，14，15，16 ----4
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
fid = fopen(['svm_result_',mask_name,'.txt'],'w');    
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
    fprintf(fid,'%s\r\n',['====',num2str(accuracy(1)),'=====']);
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
disp(['平均准确率',num2str(accracy)])
fprintf(fid,'%s\r\n',['平均准确率',num2str(accracy)]);
fclose(fid);
