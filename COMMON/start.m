spm('FnBanner',mfilename,SVNid);
% SPM8: spm_imcalc_extend (v3691)                    22:17:00 - 16/11/2016
% ========================================================================
SPMid = spm('FnBanner',mfilename,'$Rev: 3756 $');


% ����ļ�P��ͷ��Ϣ
P = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160911002\ep2d_bold_moco_p2_rest_0006\af20160911002-182750-00006-00006-1.img',
    'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160911002\ep2d_bold_moco_p2_rest_0006\af20160911002-182750-00006-00006-1.img'};
header = spm_vol(P);

% ���ͼ��ĳ�������ֵ
V = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level\20160911002\beta_0001.img'};
XYZ = [13;48;2];
Y = spm_get_data(V,XYZ);

% ��Matlab���������Ĵ���
sp=actxserver('SAPI.SpVoice');
sp.Speak('��һ�����Դ������ˣ�')