%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.factorial_design.dir = {'d:\fmri_root\yantai\aNALYSIS\second_level\first_level\'};
%%
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20160911002\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20160916001\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20160919001\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20160921001\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20160923003\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20160927003\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20161001001\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20161003002\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20161005003\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20161006002\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20161009002\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20161012003\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20161014001\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20161015002\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20161021002\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20161024002\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20161027002\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20161101002\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20161104002\con_0017.img,1'
                                                          'd:\fmri_root\yantai\aNALYSIS\first_level\20161115002\con_0017.img,1'
                                                          };
%%
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
