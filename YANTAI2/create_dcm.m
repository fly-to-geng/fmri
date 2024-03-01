function DCM = create_dcm(subject_path,VOIs,Input_a,Input_b,Input_c,name)
%���ܣ� ����DCMģ�ͣ���Ҫ�������ȡVOI����FirstLevel�ļ�������VOI_��ͷ���ļ���
%subject_path : First_Level ����Ŀ¼�� eg.D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\20160716002\
%condition_name : SPM.mat ��ƾ����ж�����������������������ɵ�DCM������
%---------------------------------------------------------------
%-����----------------------------------------------------------
%Input_a : DCMģ�;�����Ҫ����ģ�͵�ʱ���޸��������
%Input_b : ��������
%Input_c : �������
%-���ý���------------------------------------------------------
%subject_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\CB\20161215002\';
cd(subject_path);
spmmatfile = [subject_path,'SPM.mat'];
%name ='FULL'; % ���ɵ�DCMģ�͵����ƣ�
condition_mask = [1,1,1,1];
TE = 0.04; %  TE 
%Input_a = [1,1,1;1,1,1;1,1,1]; % ����DCMģ�͵����Ӿ���
%Input_b = [0,0,0;0,0,0;0,0,0]; % ������ڲ���
%Input_c = [1,1,1,1;0,0,0,0;0,0,0,0]; % �����������

% ���VOI
%------------------------------------------------
%VOIs={'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\CB\20161215002\VOI_LMGN_1.mat';
 %   'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\CB\20161215002\VOI_LA1_1.mat';
  %  'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\CB\20161215002\VOI_LV1_1.mat'};
%-------------------------------------------------
DCM = spm_dcm_specify_extend(spmmatfile,name,VOIs,condition_mask,TE,Input_a,Input_b,Input_c);
clear name;
clear VOIs;
clear condition_mask;
%spm_dcm_estimate(DCM);

