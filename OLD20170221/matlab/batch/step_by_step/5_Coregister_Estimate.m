%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.spatial.coreg.estimate.ref = {'d:\data_processing\jianlong\data_processing\img_hdr\20160713001\ep2d_bold_moco_p2_rest_0006\meanaf20160713001-185531-00006-00006-1.img,1'};
matlabbatch{1}.spm.spatial.coreg.estimate.source = {'d:\data_processing\jianlong\data_processing\img_hdr\20160713001\t1_mprage_sag_p2_0026\s20160713001-193508-00001-00176-1.img,1'};
matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
