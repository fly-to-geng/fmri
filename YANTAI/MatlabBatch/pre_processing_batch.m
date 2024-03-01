%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.temporal.st.scans = {'<UNDEFINED>'};
matlabbatch{1}.spm.temporal.st.nslices = 33;
matlabbatch{1}.spm.temporal.st.tr = 2;
matlabbatch{1}.spm.temporal.st.ta = 1.93939393939394;
matlabbatch{1}.spm.temporal.st.so = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32];
matlabbatch{1}.spm.temporal.st.refslice = 33;
matlabbatch{1}.spm.temporal.st.prefix = 'a';
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep;
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).tname = 'Session';
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).tgt_spec{1}(1).value = 'image';
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).sname = 'Slice Timing: Slice Timing Corr. Images (Sess 1)';
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).src_output = substruct('()',{1}, '.','files');
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
matlabbatch{3}.spm.spatial.coreg.estimate.ref(1) = cfg_dep;
matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).tname = 'Reference Image';
matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(1).value = 'image';
matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).sname = 'Realign: Estimate & Reslice: Mean Image';
matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).src_output = substruct('.','rmean');
matlabbatch{3}.spm.spatial.coreg.estimate.source = '<UNDEFINED>';
matlabbatch{3}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
matlabbatch{4}.spm.spatial.preproc.data(1) = cfg_dep;
matlabbatch{4}.spm.spatial.preproc.data(1).tname = 'Data';
matlabbatch{4}.spm.spatial.preproc.data(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{4}.spm.spatial.preproc.data(1).tgt_spec{1}(1).value = 'image';
matlabbatch{4}.spm.spatial.preproc.data(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{4}.spm.spatial.preproc.data(1).tgt_spec{1}(2).value = 'e';
matlabbatch{4}.spm.spatial.preproc.data(1).sname = 'Coregister: Estimate: Coregistered Images';
matlabbatch{4}.spm.spatial.preproc.data(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{4}.spm.spatial.preproc.data(1).src_output = substruct('.','cfiles');
matlabbatch{4}.spm.spatial.preproc.output.GM = [0 0 1];
matlabbatch{4}.spm.spatial.preproc.output.WM = [0 0 1];
matlabbatch{4}.spm.spatial.preproc.output.CSF = [0 0 1];
matlabbatch{4}.spm.spatial.preproc.output.biascor = 1;
matlabbatch{4}.spm.spatial.preproc.output.cleanup = 1;
matlabbatch{4}.spm.spatial.preproc.opts.tpm = {
                                               'D:\mazcx\matlabtoolbox\spm8\tpm\csf.nii,1'
                                               'D:\mazcx\matlabtoolbox\spm8\tpm\grey.nii,1'
                                               'D:\mazcx\matlabtoolbox\spm8\tpm\white.nii,1'
                                               };
matlabbatch{4}.spm.spatial.preproc.opts.ngaus = [2
                                                 2
                                                 2
                                                 4];
matlabbatch{4}.spm.spatial.preproc.opts.regtype = 'mni';
matlabbatch{4}.spm.spatial.preproc.opts.warpreg = 1;
matlabbatch{4}.spm.spatial.preproc.opts.warpco = 25;
matlabbatch{4}.spm.spatial.preproc.opts.biasreg = 0.0001;
matlabbatch{4}.spm.spatial.preproc.opts.biasfwhm = 60;
matlabbatch{4}.spm.spatial.preproc.opts.samp = 3;
matlabbatch{4}.spm.spatial.preproc.opts.msk = {''};
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1) = cfg_dep;
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tname = 'Parameter File';
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(2).value = 'e';
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).sname = 'Segment: Norm Params Subj->MNI';
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).src_output = substruct('()',{1}, '.','snfile', '()',{':'});
matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep;
matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).tname = 'Images to Write';
matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).tgt_spec{1}(1).value = 'image';
matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).tgt_spec{1}(2).value = 'e';
matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).sname = 'Realign: Estimate & Reslice: Resliced Images (Sess 1)';
matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).src_output = substruct('.','sess', '()',{1}, '.','rfiles');
matlabbatch{5}.spm.spatial.normalise.write.roptions.preserve = 0;
matlabbatch{5}.spm.spatial.normalise.write.roptions.bb = [-90 -126 -72
                                                          90 90 108];
matlabbatch{5}.spm.spatial.normalise.write.roptions.vox = [3 3 3];
matlabbatch{5}.spm.spatial.normalise.write.roptions.interp = 1;
matlabbatch{5}.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
matlabbatch{5}.spm.spatial.normalise.write.roptions.prefix = 'w';
matlabbatch{6}.spm.spatial.smooth.data(1) = cfg_dep;
matlabbatch{6}.spm.spatial.smooth.data(1).tname = 'Images to Smooth';
matlabbatch{6}.spm.spatial.smooth.data(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{6}.spm.spatial.smooth.data(1).tgt_spec{1}(1).value = 'image';
matlabbatch{6}.spm.spatial.smooth.data(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{6}.spm.spatial.smooth.data(1).tgt_spec{1}(2).value = 'e';
matlabbatch{6}.spm.spatial.smooth.data(1).sname = 'Normalise: Write: Normalised Images (Subj 1)';
matlabbatch{6}.spm.spatial.smooth.data(1).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.spm.spatial.smooth.data(1).src_output = substruct('()',{1}, '.','files');
matlabbatch{6}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{6}.spm.spatial.smooth.dtype = 0;
matlabbatch{6}.spm.spatial.smooth.im = 0;
matlabbatch{6}.spm.spatial.smooth.prefix = 's';
