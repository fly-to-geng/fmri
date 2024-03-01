function create_mask_use_T(input_img,output_img,f)
% 制作的mask乘以相应的激活之后再做成Mask
% STG_mask_path = 'D:\FMRI_ROOT\YANTAI\DESIGN\MASK\NiftiPairs_Resliced_STG.mn.img';
% spmT_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level\20160911002\spmT_0017.img';
% input_img = {STG_mask_path; spmT_path}; % 一个mask , 一个spmT图像
% output_img = 'd:\aaa.img';
%------------
P = input_img;
Q = output_img;
%f = 'i1.*(i2>3.0987)';
dmtx = 0;
mask = 0;
type = 4;
hold = 0;
flags = {dmtx,mask,type,hold};
[Q,Vo] = spm_imcalc_extend(P,Q,f,flags);