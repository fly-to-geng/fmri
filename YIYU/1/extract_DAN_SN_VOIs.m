% 抽取salience network相关区域的时间序列
first_level_root = 'D:\FMRI_ROOT\YIYU\first_level\';
pre_processing_root = 'D:\FMRI_ROOT\YIYU\pre_processing\';
filter = 'sub105*';
% 排除的被试
except_subjects = {'sub1010','sub1027','sub1029','sub1035','sub1042','sub1045','sub1054','sub1055'};
%=====================8====================================================
% 抽取SN
%=========================================================================
cd(first_level_root);
subjects = dir(filter);
diary extract_DAN_and_SN_output.txt; % 重定向控制台输出到文件
% for i = 1:size(subjects,1)
%     disp(['extract AN processing  ',subjects(i).name,'...']);
%     first_level = ([first_level_root,subjects(i).name,'\']);
%     region_names = {'dACC','lAI','RAI'};
%     region_xyz = {[0 -10 40],[-43 -11 -1],[43 -11 -1]};
%     %-----------------------
%     for j = 1:size(region_xyz,2)
%         if ~exist([first_level,'SPM.mat'],'file')
%             disp([first_level,'SPM.mat not found.****************']);
%         end
%         if ~exist([first_level,'mask.nii'],'file')
%             disp([first_level,'mask.nii not found.****************']);
%         end
%         %-----------------
%         spm_jobman('initcfg');
%         %------------------------------
%         matlabbatch{1}.spm.util.voi.spmmat = {[first_level,'SPM.mat']};
%         matlabbatch{1}.spm.util.voi.adjust = NaN;
%         matlabbatch{1}.spm.util.voi.session = 1;
%         matlabbatch{1}.spm.util.voi.name = region_names{j};
%         matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre =region_xyz{j};
%         matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = 8;
%         matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
%         matlabbatch{1}.spm.util.voi.roi{2}.mask.image = {[first_level,'mask.nii',',1']};
%         matlabbatch{1}.spm.util.voi.roi{2}.mask.threshold = 0.5;
%         matlabbatch{1}.spm.util.voi.expression = 'i1&i2';
%         spm_jobman('run',matlabbatch);
%         disp('extract regions successful !');
%         clear matlabbatch;
%     end 
% end

%=====================8====================================================
% 抽取DAN
%=========================================================================
cd(first_level_root);
subjects = dir(filter);
for i = 1:size(subjects,1)
    disp(['extract DAN processing  ',subjects(i).name,'...']);
    first_level = ([first_level_root,subjects(i).name,'\']);
    region_names = {'lFEF','rFEF','lSPL','rSPL'};
    region_xyz = {[-24 -15 66],[28 -10 58],[-24.00,-55.00,72.00],[24.00,-55.00,72.00]};
    %-----------------------
    for j = 1:size(region_xyz,2)
        if ~exist([first_level,'SPM.mat'],'file')
            disp([first_level,'SPM.mat not found.****************']);
        end
        if ~exist([first_level,'mask.nii'],'file')
            disp([first_level,'mask.nii not found.****************']);
        end
        %-----------------
        spm_jobman('initcfg');
        %------------------------------
        matlabbatch{1}.spm.util.voi.spmmat = {[first_level,'SPM.mat']};
        matlabbatch{1}.spm.util.voi.adjust = NaN;
        matlabbatch{1}.spm.util.voi.session = 1;
        matlabbatch{1}.spm.util.voi.name = region_names{j};
        matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre =region_xyz{j};
        matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = 8;
        matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
        matlabbatch{1}.spm.util.voi.roi{2}.mask.image = {[first_level,'mask.nii',',1']};
        matlabbatch{1}.spm.util.voi.roi{2}.mask.threshold = 0.5;
        matlabbatch{1}.spm.util.voi.expression = 'i1&i2';
        spm_jobman('run',matlabbatch);
        disp('extract regions successful !');
        clear matlabbatch;
    end 
end

diary off ;

sp=actxserver('SAPI.SpVoice');
sp.Speak('第一个被试处理完了！')