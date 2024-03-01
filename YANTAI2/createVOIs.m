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