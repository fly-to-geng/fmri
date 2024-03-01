clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%文件的总数
raw_filenames=cell(1,1088);
mvpa_path = 'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\';
mvpa_design = 'D:\FMRI_ROOT\YANTAI\DESIGN\';
mvpa_mask = 'D:\FMRI_ROOT\YANTAI\DESIGN\MASK'
mask_name = 'NiftiPairs_Resliced_STG.mn.img';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


cd(mvpa_design);
load('a.mat');% 标记空的TR
% 初始化一个被试的结构体，两个参数都是自己确定的命名
subj = init_subj('zjl','subj002');

%STG.img是自己制作的mask
cd(mvpa_mask)
subj = load_spm_mask(subj,'STG_category-selective',mask_name);

cd([mvpa_path,'\funcImg\20160907002']);
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
