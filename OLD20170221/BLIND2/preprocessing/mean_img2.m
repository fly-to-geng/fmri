function Q = mean_img2(input_img,output_img)
% -------------------------------------------------------------------------
% 功能：计算四个图像的平均值
% 调用：Q = mean_img2(input_img,output_img)
% 参数：
%   input_img: cell类型的输入图像的绝对路径
%   output_img: 输出图像的绝对路径
% 示例：
% input_img = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160911002\ep2d_bold_moco_p2_rest_0006\s4wraf20160911002-182750-00006-00006-1.img'
%                 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160911002\ep2d_bold_moco_p2_rest_0006\s4wraf20160911002-182752-00007-00007-1.img'
%                 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160911002\ep2d_bold_moco_p2_rest_0006\s4wraf20160911002-182754-00008-00008-1.img'
%                 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160911002\ep2d_bold_moco_p2_rest_0006\s4wraf20160911002-182756-00009-00009-1.img'};
% output_img = 'd:\out.img';
% Q = mean_img2(input_img,output_img)
% -------------------------------------------------------------------------
P = input_img;
Q = output_img;
f = '(i1+i2+i3+i4)/4';
dmtx = 0;
mask = 0;
type = 4;
hold = 0;
flags = {dmtx,mask,type,hold};

[Q,Vo] = spm_imcalc_extend(P,Q,f,flags);