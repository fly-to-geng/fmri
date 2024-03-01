function create_masks_from_multiple_labels_img()
% -------------------------------------------------------------------------
% 功能： 从多标签图像创建多个Mask
% 参数：
%   multiple_label_img_path ：多标签图像路径
%   multiple_label_path : 标签路径，名称为ROI，包含ID，Nom_C,Nom_L,ID是标签，整数，剩下的是名称
%   save_path ： 生成Mask的保存路径
%   P ： 提供重新采样的参数，需要随便一张被试的图像，Mask会按照该图像的规格重新采样

aal = 'C:\mazcx\matlabtoolbox\spm8\toolbox\wfu_pickatlas\MNI_atlas_templates\TD_label_extended_modified.img';
aal_label = 'C:\mazcx\matlabtoolbox\spm8\toolbox\wfu_pickatlas\MNI_atlas_templates\TD_label_extended_modified_List.mat';


multiple_label_img_path = aal;
multiple_label_path = aal_label;
save_path = 'D:\FMRI_ROOT\YANTAI\DESIGN\MASK\TDLabels\';

P = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160911002\ep2d_bold_moco_p2_rest_0006\wraf20160911002-182754-00008-00008-1.img';
roi_space = spm_vol(P);
% ROI names
load(multiple_label_path);
marsbar('on');
% Make ROIs
vol = spm_vol(multiple_label_img_path);
for r = 1:length(ROI)
  nom = ROI(r).Nom_L;
  func = sprintf('img == %d', ROI(r).ID); 
  o = maroi_image(struct('vol', vol, 'binarize',1,...
			 'func', func, 'descrip', nom, ...
			 'label', nom));
  cd(save_path);
  %saveroi(maroi_matrix(o), fullfile(roi_path,['MNI_' nom '_roi.mat']));
  mars_rois2img(maroi_matrix(o),['MNI_' nom '.img'],roi_space);
end