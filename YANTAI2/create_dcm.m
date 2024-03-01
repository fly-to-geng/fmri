function DCM = create_dcm(subject_path,VOIs,Input_a,Input_b,Input_c,name)
%功能： 定义DCM模型，需要先做完抽取VOI，在FirstLevel文件夹下面VOI_开头的文件；
%subject_path : First_Level 被试目录， eg.D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\20160716002\
%condition_name : SPM.mat 设计矩阵中定义的条件，这里用来给生成的DCM命名。
%---------------------------------------------------------------
%-配置----------------------------------------------------------
%Input_a : DCM模型矩阵，需要更改模型的时候，修改这个矩阵
%Input_b : 调节输入
%Input_c : 外界输入
%-配置结束------------------------------------------------------
%subject_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\CB\20161215002\';
cd(subject_path);
spmmatfile = [subject_path,'SPM.mat'];
%name ='FULL'; % 生成的DCM模型的名称；
condition_mask = [1,1,1,1];
TE = 0.04; %  TE 
%Input_a = [1,1,1;1,1,1;1,1,1]; % 定义DCM模型的连接矩阵
%Input_b = [0,0,0;0,0,0;0,0,0]; % 定义调节参数
%Input_c = [1,1,1,1;0,0,0,0;0,0,0,0]; % 定义输入参数

% 获得VOI
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

