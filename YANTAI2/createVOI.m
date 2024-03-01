function createVOI(spmT_filepath,spm_mat_path)
% ���ܣ� ʹ���ض���Mask��ȡVOI��
% spm_mat_path : SPM.mat������·������Ҫ������FirstLevel֮���SPM.mat;
% Input_u : ��ȡʱ������ʱʹ�õ�Pֵ��һ��Ĭ����0.001������ȡʧ�ܵ�ʱ�򣬣��ʵ��������ȷ���ɹ���
% -----------------------------------------------------------------------------------------
% ������Ϣ��
% contrast_name �� First_Levelʱ�����õ�contrast,�����˳�����Ҫ����Ϊ������ʹ�����ֱ�ʾÿ��contrast�ģ�
% InputMask �� appying mask : 0 none ; 1 contrast ; 2 image ;Ĭ�������� 0 
% InputthresDesc : p value adjustment to control: 'FWE' or 'none'
% Input_k : extend threshold {voxel}  0 ; Ĭ����0
% xx_mask_path : ��ȡ��VOIʹ�õ�mask�ľ���·��
% VOI_Mask ����ȡ��VOIʹ�õ�mask�ľ���·��
% Input_is �� adjust_contrst ����ѡ���Ǹ�F-All��,������1 ��dont adjust, 2 ��F-All��3�����ֱַ��Ӧ����Mask��adjust_contrst��
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


Ic = 1; % Ҫʹ�õ�contrast�ı�ţ�����1�ǵ�һ��contrast,������F contrast
InputMask = 0;  % ��ʹ��mask
InputthresDesc = 'none'; 
Input_u = 0.9999;  % ��ȡVOIʱʹ�õ�Pֵ
Input_k = 0;
empty_bit='';
Input_is = 2;
input_def = 'sphere';
input_radius = 9;

VOI_name = 'LA1'; %���ɵ�VOI������
input_xyz = input_xyz_LA1;
[SPM,xSPM] = spm_getSPM_extend(spm_mat_path,Ic,InputMask,InputthresDesc,Input_u,Input_k);
[hReg,xSPM,SPM] = spm_result_ui_extend('Setup',xSPM);
[Y xY] = spm_regions_extend(xSPM,SPM,hReg,empty_bit,VOI_name,Input_is,input_def,input_xyz,input_radius);

VOI_name = 'LV1'; %���ɵ�VOI������
input_xyz = input_xyz_LV1;
[SPM,xSPM] = spm_getSPM_extend(spm_mat_path,Ic,InputMask,InputthresDesc,Input_u,Input_k);
[hReg,xSPM,SPM] = spm_result_ui_extend('Setup',xSPM);
[Y xY] = spm_regions_extend(xSPM,SPM,hReg,empty_bit,VOI_name,Input_is,input_def,input_xyz,input_radius);


VOI_name = 'LIPS'; %���ɵ�VOI������
input_xyz = input_xyz_LIPS;
[SPM,xSPM] = spm_getSPM_extend(spm_mat_path,Ic,InputMask,InputthresDesc,Input_u,Input_k);
[hReg,xSPM,SPM] = spm_result_ui_extend('Setup',xSPM);
[Y xY] = spm_regions_extend(xSPM,SPM,hReg,empty_bit,VOI_name,Input_is,input_def,input_xyz,input_radius);