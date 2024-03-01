clear;
clc;
warning('off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%需要设置的变量
filter = '2016*';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fist_level_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_whole_s4\'};
pre_processing_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\'};
conditions_file_path = {'d:\fmri_root\yantai\DESIGN\conditons_dcm_four.mat'};
run_num = 272;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FisrtLevel分析
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(pre_processing_path{1});
subExpID=dir(filter);%=======================================

for  i=1:size(subExpID,1)
   
    wFuncImg_filenames = cell(run_num*4,1);
    multi_reg_file = cell(4,1);
    
    fist_level_path_subject = [fist_level_path{1},subExpID(i).name];
    mkdir(fist_level_path_subject); % 创建存放结果的文件夹
    cd(fist_level_path_subject);
    diary first_level_output.txt; % 重定向控制台输出到文件
	tic;  %开始计时   
    
    cd([pre_processing_path{1},subExpID(i).name]);
    subRunID = dir('ep2d*');
    for j=1:size(subRunID,1)
        cd([pre_processing_path{1},subExpID(i).name,'\',subRunID(j).name]);
        filenames = dir('s4w*.img');
        multi_regs = dir('rp_*');
        multi_reg_file{j} = [pre_processing_path{1},subExpID(i).name,'\',subRunID(j).name,'\',multi_regs.name];
        start = run_num*(j-1);
        for k=1:size(filenames,1)
            wFuncImg_filenames{start + k} = [pre_processing_path{1},subExpID(i).name,'\',subRunID(j).name,'\',filenames(k).name,',1'];
        end
    end
     
    spm_jobman('initcfg')
    %================================batch-begin===================================================%%
    matlabbatch{1}.spm.stats.fmri_spec.dir = {fist_level_path_subject};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = wFuncImg_filenames(1:run_num*4);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = conditions_file_path;
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
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
    matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
    matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
    matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
    matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
    matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 'F-All';
    matlabbatch{3}.spm.stats.con.consess{1}.fcon.convec = {
                                                           [1 0 0 0
                                                           0 1 0 0
                                                           0 0 1 0
                                                           0 0 0 1]
                                                           }';
    matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'JX';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [1 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'DW';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [0 1 0 0];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'RL';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [0 0 1 0];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'ZR';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.convec = [0 0 0 1];
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;

    %%================================batch-end=========================================================================%%
    first_level_result = spm_jobman('run',matlabbatch);
    cd(fist_level_path_subject);
    save first_level_result;
    disp('first_level successful !');
    clear matlabbatch;
    toc
    diary off;
end

