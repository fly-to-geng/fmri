function Y = extract_time_series(V,XYZ)
% -------------------------------------------------------------------------
% 功能：提取图像某个点的值并绘制时间序列曲线
% 调用：Y = plot_time_series(V,XYZ)
% 参数： 
%   XYZ ：三维坐标，图像中的点
%   V : 存放图像路径的cell
% 示例：
%   XYZ = [13;48;2];
%   V = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160911002\ep2d_bold_moco_p2_rest_0006\af20160911002-182750-00006-00006-1.img',
%    'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160911002\ep2d_bold_moco_p2_rest_0006\af20160911002-182750-00006-00006-1.img'};
%   Y = plot_time_series(V,XYZ)
% -------------------------------------------------------------------------
Y = spm_get_data(V,XYZ);
