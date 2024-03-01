
%≈‰÷√£∫
first_level_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\';
cd(first_level_path);
dir_str = dir('2016*');

for i = 1:size(dir_str,1)
    subject_path = [first_level_path,dir_str(i).name,'\'];
    create_dcm(subject_path);
end