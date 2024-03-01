%function estimate_dcm_spm12(filter)
filter = 'sub1001*';
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
        for j=1:8
            DCM_file_name = ['DCM_DMN_',int2str(j)];
            spm_dcm_fmri_csd(DCM_file_name);
        end    
    end
end

%system('shutdown -s -t 10');