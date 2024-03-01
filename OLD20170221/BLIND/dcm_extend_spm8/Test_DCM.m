% 完成单个过程，
% 1. 定义几个VOI
% 2. 定义DCM模型
% 3. 估计DCM模型
% 4. 查看DCM模型的输出并保存下来

spm_mat_path = '';
subject_path = '';
Input_u = 0.001;
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
contrast_name = {'F-All','JX','DW','RL','ZR'};
InputMask = 0;  %appying mask : 0 none ; 1 contrast ; 2 image ============================================================================
InputthresDesc = 'none';  %p value adjustment to control: 'FWE' or 'none'=================================================================
Input_k = 0; % extend threshold {voxel}  0 ===============================================================================================
HG_mask_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\MASK\HG\HG_Resliced_NiftiPairs\NiftiPairs_Resliced_HG.img';
MFG_mask_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\MASK\MFG\MFG_Resliced_NiftiPairs\NiftiPairs_Resliced_MFG.img';
STG_mask_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\MASK\STG\STG_Resliced_NiftiPairs\NiftiPairs_Resliced_STG.img';
VOI_Mask = {HG_mask_path,MFG_mask_path,STG_mask_path};
Input_is = {2,2,2}; %adjust_contrst 这里选择那个F-All的,整数，1 是dont adjust, 2 是F-All.
empty_bit = []; % 占位符，没有用处
% 配置结束
% ----------------------------------------------------------------------------------------------------------------------------------------
for j = 2:size(contrast_name,2)
    Ic = j;  % 要使用的Contrast的编号，这里1 : F-All  2: JX 3: DW 4:RL 5:ZR
    VOI_Names = {[contrast_name{Ic},'_HG'],[contrast_name{Ic},'_MFG'],[contrast_name{Ic},'_STG',]}; %Input_VOIName : 抽取的VOI的名称
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
print(fg,save_name,'-dpng');% 打印出PNG图片，还
