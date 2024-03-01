clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%需要设置的变量
filter = '20161005003*';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fist_level_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level\'};
pre_processing_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\'};
conditions_file_path = {'d:\fmri_root\yantai\DESIGN\conditions.mat'};
run_num = 272;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FisrtLevel分析
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(pre_processing_path{1});
subExpID=dir(filter);%=======================================

for  i=1:size(subExpID,1)
    diary first_level_output.txt; % 重定向控制台输出到文件
	tic;  %开始计时   
    wFuncImg_filenames = cell(run_num*4,1);
    multi_reg_file = cell(4,1);
    
    fist_level_path_subject = [fist_level_path,subExpID(i).name];
    mkdir(fist_level_path_subject); % 创建存放结果的文件夹
    
    cd([pre_processing_path{1},subExpID(i).name]);
    
    subRunID = dir('ep2d*');
    for j=1:size(subRunID,1)
        cd([pre_processing_path{1},subExpID(i).name,'\',subRunID(j).name]);
        filenames = dir('w*.img');
        multi_regs = dir('rp_*');
        multi_reg_file{j} = [pre_processing_path{1},subExpID(i).name,'\',subRunID(j).name,'\',multi_regs.name];
        start = run_num*(j-1);
        for k=1:size(filenames,1)
            wFuncImg_filenames{start + k} = [pre_processing_path{1},subExpID(i).name,'\',subRunID(j).name,'\',filenames(k).name,',1'];
        end
    end
     
    spm_jobman('initcfg')
    %================================batch-begin===================================================%%
    matlabbatch{1}.spm.stats.fmri_spec.dir =  {fist_level_path_subject};%%%%%%%%%
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = wFuncImg_filenames(1:run_num);
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = conditions_file_path; %%%%%%%%%%%%%%%%%%%%%%%%%%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = multi_reg_file(1) ;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = wFuncImg_filenames(run_num+1:run_num*2);
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi =  conditions_file_path;  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = multi_reg_file(2);
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = wFuncImg_filenames(run_num*2+1:run_num*3);
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi =  conditions_file_path;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi_reg = multi_reg_file(3);
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).hpf = 128;
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).scans = wFuncImg_filenames(run_num*3+1:run_num*4);
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi = conditions_file_path;
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi_reg = multi_reg_file(4);
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).hpf = 128;
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
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 's01';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 's02';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 's03';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 's04';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 's05';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.convec = [0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 's06';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.convec = [0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 's07';
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.convec = [0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 's08';
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.convec = [0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = 's09';
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.convec = [0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = 's10';
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.convec = [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.name = 's11';
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.name = 's12';
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{13}.tcon.name = 's13';
    matlabbatch{3}.spm.stats.con.consess{13}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{14}.tcon.name = 's14';
    matlabbatch{3}.spm.stats.con.consess{14}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{15}.tcon.name = 's15';
    matlabbatch{3}.spm.stats.con.consess{15}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{16}.tcon.name = 's16';
    matlabbatch{3}.spm.stats.con.consess{16}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{16}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{17}.tcon.name = 'JX';
    matlabbatch{3}.spm.stats.con.consess{17}.tcon.convec = [1 1 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{17}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{18}.tcon.name = 'DW';
    matlabbatch{3}.spm.stats.con.consess{18}.tcon.convec = [0 0 1 0 1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{18}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{19}.tcon.name = 'RL';
    matlabbatch{3}.spm.stats.con.consess{19}.tcon.convec = [0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 1 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{19}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{20}.tcon.name = 'ZR';
    matlabbatch{3}.spm.stats.con.consess{20}.tcon.convec = [0 0 0 0 0 0 1 0 0 1 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 1 0 0 1 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{20}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{21}.tcon.name = 'LRL';
    matlabbatch{3}.spm.stats.con.consess{21}.tcon.convec = [1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 0 0 0 0 0 0 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 0 0 0 0 0 0 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 0 0 0 0 0 0 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{21}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{22}.tcon.name = 'LRR';
    matlabbatch{3}.spm.stats.con.consess{22}.tcon.convec = [-1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 0 0 0 0 0 0 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 0 0 0 0 0 0 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 0 0 0 0 0 0 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{22}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{23}.tcon.name = 'YWZ';
    matlabbatch{3}.spm.stats.con.consess{23}.tcon.convec = [1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 0 0 0 0 0 0 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 0 0 0 0 0 0 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 0 0 0 0 0 0 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{23}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 1;

    %%================================batch-end=========================================================================%%
    first_level_result = spm_jobman('run',matlabbatch);
    save first_level_result;
    disp('first_level successful !');
    clear matlabbatch;
    toc
    diary off;
end

