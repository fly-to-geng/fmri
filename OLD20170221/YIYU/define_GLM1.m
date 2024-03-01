% 抑郁症病人的First_Level处理
% 输入：预处理过后s开头的文件
% 输出：生成的SPM.mat文件和感兴趣脑区的VOI

% 完整过程包括define_GLM1.m define_GLM2.m, 
% 程序运行中可能会出现感兴趣的脑区抽取不成功的情况，所以第一次要一个一个做
% 1.定义空的GLM模型并估计
% 2. 抽取出WM和CSF

first_level_root = 'D:\FMRI_ROOT\YIYU\first_level\';
pre_processing_root = 'D:\FMRI_ROOT\YIYU\pre_processing\';
filter = 'sub1029*';
%=========================================================================
% 定义GLM
%=========================================================================
cd(pre_processing_root);
subjects = dir(filter);
for i = 1:size(subjects,1)
    %获得图像的完整路径
    cd([pre_processing_root,subjects(i).name]);
    filenames = dir('swraf*.img');
    full_names = cell(size(filenames,1),1);
    for j = 1:size(filenames,1)
        full_names{j} = [pre_processing_root,subjects(i).name,'\',filenames(j).name,',1'];
    end
    cd(first_level_root);
    if ~exist(subjects(i).name,'dir')
        mkdir(subjects(i).name);
    end
    first_level = [first_level_root,subjects(i).name,'\'];
    diary first_level_output.txt; % 重定向控制台输出到文件
	tic;  %开始计时   
    spm_jobman('initcfg');
    %-----------------------------------------------------------------------
    % Job configuration created by cfg_util (rev $Rev: 4252 $)
    %-----------------------------------------------------------------------
    matlabbatch{1}.spm.stats.fmri_spec.dir = {first_level};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = full_names;
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'fMRI model specification: SPM.mat File';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    first_level_result = spm_jobman('run',matlabbatch);
    cd(first_level);
    save first_level_result;
    disp('first_level successful !');
    clear matlabbatch;
    toc
    diary off;
    
    if ~exist([first_level,'SPM.mat'],'file')
        disp([first_level,'SPM.mat not found.****************']);
    end
    if ~exist([first_level,'mask.nii'],'file')
        disp([first_level,'mask.nii not found.****************']);
    end
    %=========================================================================
    % 抽取WM
    %=========================================================================
    spm_jobman('initcfg');
    %-----------------
    matlabbatch{1}.spm.util.voi.spmmat = {[first_level,'SPM.mat']};
    matlabbatch{1}.spm.util.voi.adjust = NaN;
    matlabbatch{1}.spm.util.voi.session = 1;
    matlabbatch{1}.spm.util.voi.name = 'WM';
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre = [0 -24 -33];
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = 6;
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
    matlabbatch{1}.spm.util.voi.roi{2}.mask.image = {[first_level,'mask.nii,1']};
    matlabbatch{1}.spm.util.voi.roi{2}.mask.threshold = 0.5;
    matlabbatch{1}.spm.util.voi.expression = 'i1&i2';
    extract_wm = spm_jobman('run',matlabbatch);
    disp('extract_wm successful !');
    cd(first_level);
    save extract_wm;
    clear matlabbatch;
    
    %=========================================================================
    % 抽取CSF
    %=========================================================================
    spm_jobman('initcfg');
    %-----------------
    matlabbatch{1}.spm.util.voi.spmmat = {[first_level,'SPM.mat']};
    matlabbatch{1}.spm.util.voi.adjust = NaN;
    matlabbatch{1}.spm.util.voi.session = 1;
    matlabbatch{1}.spm.util.voi.name = 'CSF';
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre = [0 -40 5];
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = 6;
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
    matlabbatch{1}.spm.util.voi.roi{2}.mask.image = {[first_level,'mask.nii,1']};
    matlabbatch{1}.spm.util.voi.roi{2}.mask.threshold = 0.5;
    matlabbatch{1}.spm.util.voi.expression = 'i1&i2';
    extract_csf = spm_jobman('run',matlabbatch);
    disp('extract_csf successful !');
    cd(first_level);
    save extract_csf;
    clear matlabbatch;
        
    %=========================================================================
    % 应用回归（头动参数和CSF抽取的序列）
    %=========================================================================
    % 删除已经有的SPM.mat文件
    cd(first_level);
    if exist('SPM.mat','file')
        delete('SPM.mat');
    end
    
    % 找到头动文件
    multi_reg_file = cell(3,1);
    cd([pre_processing_root,subjects(i).name]);
    head_move = dir('rp*');
    
    csf_file = [first_level,'VOI_CSF_1.mat'];
    if ~exist(csf_file,'file')
        disp([csf_file,'not found. ****************']);
    end
    wm_file = [first_level,'VOI_WM_1.mat'];
    if ~exist(wm_file,'file')
       disp([wm_file,'not found. ****************']); 
    end
    multi_reg_file{1} = csf_file;
    multi_reg_file{2} = wm_file;
    multi_reg_file{3} = head_move(1).name;
    %------------------------
    spm_jobman('initcfg');
    %-----------------------------------------------------------------------
    matlabbatch{1}.spm.stats.fmri_spec.dir = {first_level};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = full_names;
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = multi_reg_file;
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    %-------------------------------------------
    define_glm2 = spm_jobman('run',matlabbatch);
    disp('define_GLM2 successful !');
    cd(first_level);
    save define_glm2;
    clear matlabbatch;
    
    
end






