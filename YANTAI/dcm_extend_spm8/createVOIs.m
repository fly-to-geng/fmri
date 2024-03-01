% 创建多个被试的VOI；
% 
first_level_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\';
cd(first_level_path);
dir_str = dir('2016*');
Input_u = 0.001; % P值；抽取不成功时，调大P值可以成功
for i = 1:size(dir_str,1)
    spm_mat_path = [first_level_path,dir_str(i).name,'\SPM.mat'];
    createVOI(spm_mat_path);
end