function Y = extract_time_series(V,XYZ)
% -------------------------------------------------------------------------
% ���ܣ���ȡͼ��ĳ�����ֵ������ʱ����������
% ���ã�Y = plot_time_series(V,XYZ)
% ������ 
%   XYZ ����ά���꣬ͼ���еĵ�
%   V : ���ͼ��·����cell
% ʾ����
%   XYZ = [13;48;2];
%   V = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160911002\ep2d_bold_moco_p2_rest_0006\af20160911002-182750-00006-00006-1.img',
%    'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160911002\ep2d_bold_moco_p2_rest_0006\af20160911002-182750-00006-00006-1.img'};
%   Y = plot_time_series(V,XYZ)
% -------------------------------------------------------------------------
Y = spm_get_data(V,XYZ);
