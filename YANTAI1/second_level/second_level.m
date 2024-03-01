%function second_level(filter)
% -------------------------------------------------------------------------
% 功能：second_level分析
% 调用：second_level(filter)
% 参数：
%   filter:控制处理的被试数量，例如'20161001*'
% 示例：
%   filter = '20161011*';
%   first_level(filter);
% 说明：更换该函数中Batch部分可以做不同的second_level任务
% -------------------------------------------------------------------------
filter = '2016*';
first_level_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_s8\';
second_level_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\second_level\first_level_s8\';
subject_num = 20;

cd(first_level_path);
SubExpID = dir(filter);
JX_T_files = cell(subject_num,1);
DW_T_files = cell(subject_num,1);
RL_T_files = cell(subject_num,1);
ZR_T_files = cell(subject_num,1);
for i=1:size(SubExpID,1)
   cd([first_level_path,SubExpID(i).name]);
   JX = dir('con_0017.img*');
   DW = dir('con_0018.img*');
   RL = dir('con_0019.img*');
   ZR = dir('con_0020.img*');
   JX_T_files{i} = [first_level_path,SubExpID(i).name,'\',JX(1).name,',1'];
   DW_T_files{i} = [first_level_path,SubExpID(i).name,'\',DW(1).name,',1'];
   RL_T_files{i} = [first_level_path,SubExpID(i).name,'\',RL(1).name,',1'];
   ZR_T_files{i} = [first_level_path,SubExpID(i).name,'\',ZR(1).name,',1'];
end
T_files = {JX_T_files,DW_T_files,RL_T_files,ZR_T_files};
second_names = {'JX','DW','RL','ZR'};
for j = 1:4
    cd(second_level_path);
    if ~exist(second_names{j},'dir')
       mkdir(second_names{j}); 
    end
    spm_jobman('initcfg')
    %================================batch-begin===================================================%%
    matlabbatch{1}.spm.stats.factorial_design.dir = {[second_level_path,second_names{j}]};
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = T_files{j};
    matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
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
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Single';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1;
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 1;
    second_level_result = spm_jobman('run',matlabbatch);
    cd(second_level_path);
    save second_level_result;
    disp('second_level successful !');
    clear matlabbatch;
end