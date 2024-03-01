
% ¹À¼ÆDCMÄ£ÐÍ
first_level_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\CB\';
cd(first_level_path);
dir_path = dir('20*');
for i = 1: size(dir_path,1)
    subject_path = [first_level_path,dir_path(i).name];
    cd(subject_path);
    dcm_models_path = dir('DCM_R*');
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
    dcm_models_path = dir('DCM_R*');
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
    dcm_models_path = dir('DCM_R*');
    for j = 1:size(dcm_models_path,1)
       dcm_model_path =  [subject_path,'\',dcm_models_path(j).name];
       spm_dcm_estimate(dcm_model_path);
    end
end