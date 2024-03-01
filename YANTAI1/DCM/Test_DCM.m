% ��ɵ������̣�
% 1. ���弸��VOI
% 2. ����DCMģ��
% 3. ����DCMģ��
% 4. �鿴DCMģ�͵��������������

spm_mat_path = '';
subject_path = '';
Input_u = 0.001;
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
contrast_name = {'F-All','JX','DW','RL','ZR'};
InputMask = 0;  %appying mask : 0 none ; 1 contrast ; 2 image ============================================================================
InputthresDesc = 'none';  %p value adjustment to control: 'FWE' or 'none'=================================================================
Input_k = 0; % extend threshold {voxel}  0 ===============================================================================================
HG_mask_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\MASK\HG\HG_Resliced_NiftiPairs\NiftiPairs_Resliced_HG.img';
MFG_mask_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\MASK\MFG\MFG_Resliced_NiftiPairs\NiftiPairs_Resliced_MFG.img';
STG_mask_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\MASK\STG\STG_Resliced_NiftiPairs\NiftiPairs_Resliced_STG.img';
VOI_Mask = {HG_mask_path,MFG_mask_path,STG_mask_path};
Input_is = {2,2,2}; %adjust_contrst ����ѡ���Ǹ�F-All��,������1 ��dont adjust, 2 ��F-All.
empty_bit = []; % ռλ����û���ô�
% ���ý���
% ----------------------------------------------------------------------------------------------------------------------------------------
for j = 2:size(contrast_name,2)
    Ic = j;  % Ҫʹ�õ�Contrast�ı�ţ�����1 : F-All  2: JX 3: DW 4:RL 5:ZR
    VOI_Names = {[contrast_name{Ic},'_HG'],[contrast_name{Ic},'_MFG'],[contrast_name{Ic},'_STG',]}; %Input_VOIName : ��ȡ��VOI������
    [SPM,xSPM] = spm_getSPM_extend(spm_mat_path,Ic,InputMask,InputthresDesc,Input_u,Input_k);
    [hReg,xSPM,SPM] = spm_result_ui_extend('Setup',xSPM);
    for i = 1:size(VOI_Mask,2)
        [Y xY] = spm_regions_extend(xSPM,SPM,hReg,empty_bit,VOI_Names{i},Input_is{i},VOI_Mask{i});
    end
    clear SPM;
    clear xSPM;
end

DCM = create_dcm();
spm_dcm_estimate(DCM);
spm_dcm_review_extend(DCM,'outputs');
fg=spm_figure('FindWin','Graphics');
[path,name,exit] = fileparts(dcm_model_path);
save_name = ['output_',dir_path(i).name,'_',name];
cd(first_level_path);
print(fg,save_name,'-dpng');% ��ӡ��PNGͼƬ����
