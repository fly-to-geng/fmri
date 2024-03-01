% 将marsbar生成的ROI转换成图像格式
root_path = 'D:\FMRI_ROOT\TOOLS\marsbar\marsbar-aal-0.2\';
save_path = 'D:\FMRI_ROOT\YANTAI\DESIGN\MASK\AAL\';
if ~exist(save_path,'dir')
   mkdir(save_path); 
end
P = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160911002\ep2d_bold_moco_p2_rest_0006\wraf20160911002-182754-00008-00008-1.img';
roi_space = spm_vol(P);
cd(root_path);
AAL = dir('MNI*');
for i = 1:size(AAL,1)
    roi_list = [root_path,AAL(i).name];
    [PATHSTR,NAME,EXT] = fileparts(roi_list); 
    cd(save_path);
    mars_rois2img(roi_list,[NAME,'.img'],roi_space);
    clear roi_list NAME;
end