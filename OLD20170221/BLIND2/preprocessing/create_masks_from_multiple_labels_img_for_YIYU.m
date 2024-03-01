function create_masks_from_multiple_labels_img_for_YIYU()
% -------------------------------------------------------------------------
% ���ܣ� �Ӷ��ǩͼ�񴴽����Mask
% ������
%   multiple_label_img_path �����ǩͼ��·��
%   multiple_label_path : ��ǩ·��������ΪROI������ID��Nom_C,Nom_L,ID�Ǳ�ǩ��������ʣ�µ�������
%   save_path �� ����Mask�ı���·��
%   P �� �ṩ���²����Ĳ�������Ҫ���һ�ű��Ե�ͼ��Mask�ᰴ�ո�ͼ��Ĺ�����²���

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