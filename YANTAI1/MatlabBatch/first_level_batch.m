%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_spec.dir = '<UNDEFINED>';
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {'d:\fmri_root\yantai\DESIGN\conditions.mat'};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = '<UNDEFINED>';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = {'d:\fmri_root\yantai\DESIGN\conditions.mat'};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = '<UNDEFINED>';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi = {'d:\fmri_root\yantai\DESIGN\conditions.mat'};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi_reg = '<UNDEFINED>';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi = {'d:\fmri_root\yantai\DESIGN\conditions.mat'};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi_reg = '<UNDEFINED>';
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
matlabbatch{3}.spm.stats.con.delete = 0;