function check_img(imgs)
% -------------------------------------------------------------------------
% 功能：比较多幅图像
% 调用：check_img(imgs)
% 参数：
%   imgs: cell类型的图像
% 示例：
%   c1_img = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160713001\t1_mprage_sag_p2_0026\run1\c1s20160713001-193508-00001-00176-1.img';
%   c2_img = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160713001\t1_mprage_sag_p2_0026\run1\c2s20160713001-193508-00001-00176-1.img';
%   c3_img = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160713001\t1_mprage_sag_p2_0026\run1\c3s20160713001-193508-00001-00176-1.img';
%   func_img = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160713001\ep2d_bold_moco_p2_rest_0006\f20160713001-190315-00238-00238-1.img';
%   imgs = {c1_img,c2_img,c3_img,func_img};
%   check_img(imgs);
% -------------------------------------------------------------------------
spm_jobman('initcfg')
matlabbatch{1}.spm.util.checkreg.data = imgs;
spm_jobman('run',matlabbatch);

