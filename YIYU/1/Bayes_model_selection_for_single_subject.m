% bayes model selection subject-by-subject
% 贝叶斯模型选择，每个被试单独选择模型，被试间彼此独立
filter = 'sub*';

first_level_path = 'D:\FMRI_ROOT\YIYU\first_level\';
bayes_model_selection_result = 'D:\FMRI_ROOT\YIYU\BMS\'; % 结果保存路径

if ~exist(bayes_model_selection_result,'dir')
    mkdir(bayes_model_selection_result);
end

subjects_exception = {'sub1010','sub1029','sub1027','sub1035','sub1042','sub1054','sub1055'};
DCM_model_names = {'DCM_DMN.mat','DCM_DMN_1.mat','DCM_DMN_2.mat','DCM_DMN_3.mat','DCM_DMN_4.mat','DCM_DMN_5.mat','DCM_DMN_6.mat','DCM_DMN_7.mat','DCM_DMN_8.mat'};
cd(first_level_path);
subjects_dir = dir(filter);
for i=1:size(subjects_dir,1)
    disp(['=======================',subjects_dir(i).name,'precessing ... =======================================']);
    if ~any( ismember(subjects_exception,subjects_dir(i).name) )
        DCM_files = cell(size(DCM_model_names,2),1);
        for j=1:size(DCM_files,1)
            DCM_files{j} = [first_level_path,subjects_dir(i).name,'\',DCM_model_names{j}];
        end
    
        save_path = [bayes_model_selection_result,subjects_dir(i).name];
        if ~exist(save_path,'dir')
            mkdir(save_path);
        end
         spm_jobman('initcfg')
         %--------------------------------
        matlabbatch{1}.spm.dcm.bms.inference.dir = {save_path};
        matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{1}.dcmmat = DCM_files;
        matlabbatch{1}.spm.dcm.bms.inference.model_sp = {''};
        matlabbatch{1}.spm.dcm.bms.inference.load_f = {''};
        matlabbatch{1}.spm.dcm.bms.inference.method = 'FFX';
        matlabbatch{1}.spm.dcm.bms.inference.family_level.family_file = {''};
        matlabbatch{1}.spm.dcm.bms.inference.bma.bma_no = 0;
        matlabbatch{1}.spm.dcm.bms.inference.verify_id = 0;   
        BMS = spm_jobman('run',matlabbatch);
        cd(save_path);
        save BMS;
        save_name = 'BMS_Result';
        fg=spm_figure('FindWin','Graphics');
        spm_print(save_name);
        print(fg,save_name,'-dpng');% 打印出PNG图片，还可以输出其他的格式，参考Matlab的print函数。
        clear matlabbatch fg BMS save_path save_name;
    end
end