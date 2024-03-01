%function estimate_dcm_spm12(filter)
filter = 'sub*';
% 估计DCM，这个比较耗时，所以放在一起进行
first_level_root = 'D:\FMRI_ROOT\YIYU\first_level\';
except_cells = {'sub1010','sub1027','sub1029','sub1035','sub1042','sub1054','sub1055'};
DCM_file_name = 'DCM_DMN';
cd(first_level_root);
subjects = dir(filter);

for i = 1:size(subjects,1)
    if ~any( ismember(except_cells,subjects(i).name) )
        disp([subjects(i).name,' processing ...']);
        subject_path = ([first_level_root,subjects(i).name,'\']); 
        cd(subject_path);
        DCM_file_name1 = 'DCM_SN_1';
        DCM_file_name2 = 'DCM_DAN_1';
        spm_dcm_fmri_csd(DCM_file_name1); 
        spm_dcm_fmri_csd(DCM_file_name2); 
    end
end

pre_processing('20170108001*');
pre_processing('20170108003*');
first_level('20170108001*');
first_level('20170108001*');
system('shutdown -s -t 10');