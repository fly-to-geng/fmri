% bayes model selection for multiple subjects
% 多个被试在一起做模型选择，选择出来的结果是多个被试的一个平均结果
filter = 'sub*';

first_level_path = 'D:\FMRI_ROOT\YIYU\first_level\';
bayes_model_selection_result = 'D:\FMRI_ROOT\YIYU\BMS\'; % 结果保存路径

if ~exist(bayes_model_selection_result,'dir')
    mkdir(bayes_model_selection_result);
end

subjects_exception = {'sub1010','sub1029','sub1027','sub1035','sub1042','sub1054','sub1055'};
NC_subjects = {'sub1001','sub1002','sub1003',...
    'sub1004','sub1005','sub1006','sub1007',...
    'sub1008','sub1009','sub1011',...
    'sub1012','sub1012','sub1014','sub1015',...
    'sub1016','sub1017','sub1018','sub1019',...
    'sub1020','sub1021','sub1022','sub1023',...
    'sub1024','sub1025','sub1026',...
    'sub1028'};
MDD_subjects =  {'sub1030','sub1031','sub1032',...
    'sub1033','sub1034','sub1036',...
    'sub1037','sub1038','sub1039','sub1040',...
    'sub1041','sub1043','sub1044',...
    'sub1045','sub1046','sub1047','sub1048',...
    'sub1049','sub1050','sub1051','sub1052',...
    'sub1053'};
DCM_model_names = {'DCM_DMN.mat','DCM_DMN_1.mat','DCM_DMN_2.mat','DCM_DMN_3.mat','DCM_DMN_4.mat','DCM_DMN_5.mat','DCM_DMN_6.mat','DCM_DMN_7.mat','DCM_DMN_8.mat'};
cd(first_level_path);
subjects_dir = dir(filter);
%---------------------
spm_jobman('initcfg')
%--------------------------------
matlabbatch{1}.spm.dcm.bms.inference.dir = {bayes_model_selection_result};
count_num = 1;
for i=1:size(subjects_dir,1)
    if ~any( ismember(subjects_exception,subjects_dir(i).name) ) && ~any( ismember(NC_subjects,subjects_dir(i).name) )
        DCM_files = cell(size(DCM_model_names,2),1);
        for j=1:size(DCM_files,1)
            DCM_files{j} = [first_level_path,subjects_dir(i).name,'\',DCM_model_names{j}];
        end
        matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{count_num}.dcmmat = DCM_files;
        count_num = count_num + 1;
     end
end
    
matlabbatch{1}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{1}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{1}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{1}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{1}.spm.dcm.bms.inference.bma.bma_no = 0;
matlabbatch{1}.spm.dcm.bms.inference.verify_id = 0;   
BMS_MDD = spm_jobman('run',matlabbatch);
cd(bayes_model_selection_result);
save BMS_MDD;
save_name = 'BMS_MDD_Result';
fg=spm_figure('FindWin','Graphics');
spm_print(save_name);
print(fg,save_name,'-dpng');% 打印出PNG图片，还可以输出其他的格式，参考Matlab的print函数。
clear matlabbatch;