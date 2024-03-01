function createVOI(spmT_filepath,spm_mat_path)
% 功能： 使用特定的Mask抽取VOI。
% spm_mat_path : SPM.mat的完整路径，需要是做完FirstLevel之后的SPM.mat;
% Input_u : 抽取时间序列时使用的P值，一般默认是0.001，当抽取失败的时候，，适当调大可以确保成功；
% -----------------------------------------------------------------------------------------
% 配置信息：
% contrast_name ： First_Level时候设置的contrast,这里的顺序很重要，因为程序中使用数字表示每个contrast的；
% InputMask ： appying mask : 0 none ; 1 contrast ; 2 image ;默认是整数 0 
% InputthresDesc : p value adjustment to control: 'FWE' or 'none'
% Input_k : extend threshold {voxel}  0 ; 默认是0
% xx_mask_path : 抽取的VOI使用的mask的绝对路径
% VOI_Mask ：抽取的VOI使用的mask的绝对路径
% Input_is ： adjust_contrst 这里选择那个F-All的,整数，1 是dont adjust, 2 是F-All，3个数字分别对应三个Mask的adjust_contrst。
%spmT_filepath = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\HC\20160911002\spmF_0001.nii';
%spm_mat_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\HC\20160911002\SPM.mat';
%xjview(spmT_filepath);

%%% -- dcm_mode_1
% input_xyz_LMGN = [-12;-26;-6];
% input_xyz_LA1 = [-54;-14;2];
% input_xyz_LV1 = [-6;-74;6];

% input_xyz_RMGN = [16;-24;-6];
% input_xyz_RA1 = [54;-14;6];
% input_xyz_RV1 = [4;-80;8];


%%% DCM_mode_2
input_xyz_LA1 = [-60;-34;14];
input_xyz_LIPS = [-40;-40;42];
input_xyz_LV1 = [-8;-82;8];

input_xyz_RA1 = [64;-26;10];
input_xyz_RIPS = [42;-38;48];
input_xyz_RV1 = [22;-98;2];

% xyz_LMGN = find_peak_co(spmT_filepath,input_xyz_LMGN);
% xyz_LA1 = find_peak_co(spmT_filepath,input_xyz_LA1);
% xyz_LV1 = find_peak_co(spmT_filepath,input_xyz_LV1);


Ic = 1; % 要使用的contrast的编号，这里1是第一个contrast,这里是F contrast
InputMask = 0;  % 不使用mask
InputthresDesc = 'none'; 
Input_u = 0.9999;  % 抽取VOI时使用的P值
Input_k = 0;
empty_bit='';
Input_is = 2;
input_def = 'sphere';
input_radius = 9;

VOI_name = 'LA1'; %生成的VOI的名称
input_xyz = input_xyz_LA1;
[SPM,xSPM] = spm_getSPM_extend(spm_mat_path,Ic,InputMask,InputthresDesc,Input_u,Input_k);
[hReg,xSPM,SPM] = spm_result_ui_extend('Setup',xSPM);
[Y xY] = spm_regions_extend(xSPM,SPM,hReg,empty_bit,VOI_name,Input_is,input_def,input_xyz,input_radius);

VOI_name = 'LV1'; %生成的VOI的名称
input_xyz = input_xyz_LV1;
[SPM,xSPM] = spm_getSPM_extend(spm_mat_path,Ic,InputMask,InputthresDesc,Input_u,Input_k);
[hReg,xSPM,SPM] = spm_result_ui_extend('Setup',xSPM);
[Y xY] = spm_regions_extend(xSPM,SPM,hReg,empty_bit,VOI_name,Input_is,input_def,input_xyz,input_radius);


VOI_name = 'LIPS'; %生成的VOI的名称
input_xyz = input_xyz_LIPS;
[SPM,xSPM] = spm_getSPM_extend(spm_mat_path,Ic,InputMask,InputthresDesc,Input_u,Input_k);
[hReg,xSPM,SPM] = spm_result_ui_extend('Setup',xSPM);
[Y xY] = spm_regions_extend(xSPM,SPM,hReg,empty_bit,VOI_name,Input_is,input_def,input_xyz,input_radius);