function create_masks_from_multiple_labels_img_for_YIYU()
% -------------------------------------------------------------------------
% 功能： 从多标签图像创建多个Mask
% 参数：
%   multiple_label_img_path ：多标签图像路径
%   multiple_label_path : 标签路径，名称为ROI，包含ID，Nom_C,Nom_L,ID是标签，整数，剩下的是名称
%   save_path ： 生成Mask的保存路径
%   P ： 提供重新采样的参数，需要随便一张被试的图像，Mask会按照该图像的规格重新采样

aal = 'D:\FMRI_ROOT\YIYU\ROIs\AAL\multiple_label_single_file\atlas.nii';
aal_label = 'D:\FMRI_ROOT\YIYU\ROIs\AAL\multiple_label_single_file\ROI.mat';


multiple_label_img_path = aal;
multiple_label_path = aal_label;
save_path = 'D:\FMRI_ROOT\YIYU\ROIs\AAL\mutiple_file\';

P = 'D:\FMRI_ROOT\YIYU\pre_processing\sub1001\wraf507-0004-00226-000226-01.img';
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
  mars_rois2img(maroi_matrix(o),['MNI_' num2str(r) '.img'],roi_space);
end