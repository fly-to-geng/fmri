% 所有的过程
first_level_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\CB\';
filter = '20*';
cd(first_level_path);
subjects = dir(filter); %run 文件夹
for i=1:size(subjects,1)
    spm_mat_path = fullfile(first_level_path,subjects(i).name,'spmF_0001.nii');
    spmT_filepath = fullfile(first_level_path,subjects(i).name,'SPM.mat');
    createVOI(spmT_filepath,spm_mat_path);
end

clear;
clc;
first_level_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\BS\';
filter = '20*';
cd(first_level_path);
subjects = dir(filter); %run 文件夹
for i=1:size(subjects,1)
    spm_mat_path = fullfile(first_level_path,subjects(i).name,'spmF_0001.nii');
    spmT_filepath = fullfile(first_level_path,subjects(i).name,'SPM.mat');
    createVOI(spmT_filepath,spm_mat_path);
end



clear;
clc;
first_level_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\HC\';
filter = '20*';
cd(first_level_path);
subjects = dir(filter); %run 文件夹
for i=1:size(subjects,1)
    spm_mat_path = fullfile(first_level_path,subjects(i).name,'spmF_0001.nii');
    spmT_filepath = fullfile(first_level_path,subjects(i).name,'SPM.mat');
    createVOI(spmT_filepath,spm_mat_path);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;

%DCM 模型空间的定义
Input_b = [0,0,0;0,0,0;0,0,0]; % 定义调节参数
Input_c = [1,1,1,1;0,0,0,0;0,0,0,0]; % 定义输入参数


%%% == dcm_mode_1
% DCMs(1).a = [1,1,1;1,1,1;1,1,1];
% DCMs(1).b = Input_b;
% DCMs(1).c = Input_c;
% DCMs(1).name = 'RIN01';
% 
% DCMs(2).a = [1,0,1;0,1,1;1,1,1];
% DCMs(2).b = Input_b;
% DCMs(2).c = Input_c;
% DCMs(2).name = 'RIN02';
% 
% DCMs(3).a = [1,1,0;1,1,1;0,1,1];
% DCMs(3).b = Input_b;
% DCMs(3).c = Input_c;
% DCMs(3).name = 'RIN03';
% 
% DCMs(4).a = [1,1,1;1,1,0;1,0,1];
% DCMs(4).b = Input_b;
% DCMs(4).c = Input_c;
% DCMs(4).name = 'RIN04';
% 
% DCMs(5).a = [1,1,1;0,1,0;0,1,1];
% DCMs(5).b = Input_b;
% DCMs(5).c = Input_c;
% DCMs(5).name = 'REX01';
% 
% DCMs(6).a = [1,0,1;0,1,0;0,1,1];
% DCMs(6).b = Input_b;
% DCMs(6).c = Input_c;
% DCMs(6).name = 'REX02';
% 
% DCMs(7).a = [1,1,0;0,1,1;0,0,1];
% DCMs(7).b = Input_b;
% DCMs(7).c = Input_c;
% DCMs(7).name = 'REX03';
% 
% DCMs(8).a = [1,1,1;0,1,0;0,0,1];
% DCMs(8).b = Input_b;
% DCMs(8).c = Input_c;
% DCMs(8).name = 'REX04';

%%%% dcm_mode_2 
Input_b = [0,0,0;0,0,0;0,0,0]; % 定义调节参数
Input_c = [1,1,1,1;0,0,0,0;0,0,0,0]; % 定义输入参数

DCMs(1).a = [1,1,0;0,1,1;0,0,1];
DCMs(1).b = Input_b;
DCMs(1).c = Input_c;
DCMs(1).name = 'L201';

DCMs(2).a = [1,0,1;0,1,0;0,1,1];
DCMs(2).b = Input_b;
DCMs(2).c = Input_c;
DCMs(2).name = 'L202';

DCMs(3).a = [1,1,1;0,1,1;0,0,1];
DCMs(3).b = Input_b;
DCMs(3).c = Input_c;
DCMs(3).name = 'L203';

DCMs(4).a = [1,1,1;0,1,0;0,1,1];
DCMs(4).b = Input_b;
DCMs(4).c = Input_c;
DCMs(4).name = 'L204';

DCMs(5).a = [1,1,0;1,1,1;0,1,1];
DCMs(5).b = Input_b;
DCMs(5).c = Input_c;
DCMs(5).name = 'L205';

DCMs(6).a = [1,0,1;0,1,1;1,1,1];
DCMs(6).b = Input_b;
DCMs(6).c = Input_c;
DCMs(6).name = 'L206';

DCMs(7).a = [1,1,1;1,1,1;1,1,1];
DCMs(7).b = Input_b;
DCMs(7).c = Input_c;
DCMs(7).name = 'L207';

dir_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\CB\';
VOI_names = {'VOI_LA1_1.mat';'VOI_LIPS_1.mat';'VOI_LV1_1.mat'};
cd(dir_path);
subject_dirs = dir('20*');
clear subjects;
for i=1:size(subject_dirs,1)
    subjects(i).path = fullfile(dir_path,subject_dirs(i).name,'\');
    subjects(i).VOIs = {fullfile(subjects(i).path,VOI_names{1});
                   fullfile(subjects(i).path,VOI_names{2});
                   fullfile(subjects(i).path,VOI_names{3})};
end

for j = 1:size(subjects,2)
    for i=1:size(DCMs,2)
        DCM = create_dcm(subjects(j).path,subjects(j).VOIs,DCMs(i).a,DCMs(i).b,DCMs(i).c,DCMs(i).name);
    end
end


dir_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\BS\';
VOI_names = {'VOI_LA1_1.mat';'VOI_LIPS_1.mat';'VOI_LV1_1.mat'};
cd(dir_path);
subject_dirs = dir('20*');
clear subjects;
for i=1:size(subject_dirs,1)
    subjects(i).path = fullfile(dir_path,subject_dirs(i).name,'\');
    subjects(i).VOIs = {fullfile(subjects(i).path,VOI_names{1});
                   fullfile(subjects(i).path,VOI_names{2});
                   fullfile(subjects(i).path,VOI_names{3})};
end

for j = 1:size(subjects,2)
    for i=1:size(DCMs,2)
        DCM = create_dcm(subjects(j).path,subjects(j).VOIs,DCMs(i).a,DCMs(i).b,DCMs(i).c,DCMs(i).name);
    end
end

dir_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\HC\';
VOI_names = {'VOI_LA1_1.mat';'VOI_LIPS_1.mat';'VOI_LV1_1.mat'};
cd(dir_path);
subject_dirs = dir('20*');
clear subjects;
for i=1:size(subject_dirs,1)
    subjects(i).path = fullfile(dir_path,subject_dirs(i).name,'\');
    subjects(i).VOIs = {fullfile(subjects(i).path,VOI_names{1});
                   fullfile(subjects(i).path,VOI_names{2});
                   fullfile(subjects(i).path,VOI_names{3})};
end

for j = 1:size(subjects,2)
    for i=1:size(DCMs,2)
        DCM = create_dcm(subjects(j).path,subjects(j).VOIs,DCMs(i).a,DCMs(i).b,DCMs(i).c,DCMs(i).name);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
% 估计DCM模型
first_level_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\CB\';
cd(first_level_path);
dir_path = dir('20*');
for i = 1: size(dir_path,1)
    subject_path = [first_level_path,dir_path(i).name];
    cd(subject_path);
    dcm_models_path = dir('DCM_L*');
    for j = 1:size(dcm_models_path,1)
       dcm_model_path =  [subject_path,'\',dcm_models_path(j).name];
       spm_dcm_estimate(dcm_model_path);
    end
end


first_level_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\BS\';
cd(first_level_path);
dir_path = dir('20*');
for i = 1: size(dir_path,1)
    subject_path = [first_level_path,dir_path(i).name];
    cd(subject_path);
    dcm_models_path = dir('DCM_L*');
    for j = 1:size(dcm_models_path,1)
       dcm_model_path =  [subject_path,'\',dcm_models_path(j).name];
       spm_dcm_estimate(dcm_model_path);
    end
end


first_level_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\HC\';
cd(first_level_path);
dir_path = dir('20*');
for i = 1: size(dir_path,1)
    subject_path = [first_level_path,dir_path(i).name];
    cd(subject_path);
    dcm_models_path = dir('DCM_L*');
    for j = 1:size(dcm_models_path,1)
       dcm_model_path =  [subject_path,'\',dcm_models_path(j).name];
       spm_dcm_estimate(dcm_model_path);
    end
end

