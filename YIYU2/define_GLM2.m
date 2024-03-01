% ����֢���˵�First_Level����
% ���룺Ԥ�������s��ͷ���ļ�
% ��������ɵ�SPM.mat�ļ��͸���Ȥ������VOI

% 3. ʹ��WM��CSF��ͷ���������¶���GLM������
% 4. ��ȡ4��������ʱ��������Ϣ
first_level_root = 'D:\FMRI_ROOT\YIYU\first_level\';
pre_processing_root = 'D:\FMRI_ROOT\YIYU\pre_processing\';
filter = 'sub1029*';
%=====================8====================================================
% ����GLM
%=========================================================================
cd(first_level_root);
subjects = dir(filter);
for i = 1:size(subjects,1)
    
    first_level = ([first_level_root,subjects(i).name,'\']);
    
    %=========================================================================
    % ��ȡ4�������ʱ������
    %=========================================================================
    region_names = {'PCC','mPFC','RIPC','LIPC'};
    region_xyz = {[0 -52 26],[3 54 -2],[48 -69 35],[-50 -63 32]};
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
define_DCM_spm12(filter);

estimate_dcm_spm12(filter);