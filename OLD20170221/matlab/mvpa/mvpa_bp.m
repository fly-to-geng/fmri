clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ʹ��MVPA���߰��ṩ��BP�㷨����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�ļ�������
raw_filenames=cell(1,1088);
mvpa_path = 'D:\data_processing\jianlong\data_processing\mvpa\20160716002\';
mvpa_design = 'D:\data_processing\jianlong\data_processing\mvpa\design\';
mask_name = 'STG.img';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


cd(mvpa_design);
load('a.mat');% ��ǿյ�TR
load('tutorial_regs');
% ��ʼ��һ�����ԵĽṹ�壬�������������Լ�ȷ��������
subj = init_subj('zjl','subj002');

%STG.img���Լ�������mask
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
subj = init_object(subj,'regressors','conds');

% 
subj = set_mat(subj,'regressors','conds',tutorial_regs);
condnames = {'H','A','M','N'};
subj = set_objfield(subj,'regressors','conds','condnames',condnames);

% store the names of the regressor conditions
% initialize the selectors object, then read in the contents
% for it from a file, and set them into the object
subj = init_object(subj,'selector','runs');
cd(mvpa_design);
load('tutorial_runs');%���ÿ��TR�����ĸ�run
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

subj = feature_select(subj,'epi_z','conds','runs_xval')%ʹ�÷������ѡ������
%ɾ����TR,���ݾ���a�е�����
for i=1088:-1:1
    for j=1:320
       if i==a(j,1)
          after_zscore(i,:)=[];
       end
    end
end

data_STG_raw=after_zscore(:,2:end);
load label;%���ÿһ���ǿյ�TR��ʾ�����
data_STG=zeros(768,size(data_STG_raw,2)+1);
data_STG(1:768,1)=label(1:768,1);
data_STG(1:768,2:end)=data_STG_raw(1:768,1:end);
cd(mvpa_path);
save(['data_',mask_name,'.mat'],'data_STG');


 class_args.train_funct_name = 'train_bp';
 class_args.test_funct_name = 'test_bp';
 class_args.nHidden = 0;
 
 [subj, results] = cross_validation(subj,'epi_z','conds','runs_xval','epi_z_thresh0.05',class_args);
