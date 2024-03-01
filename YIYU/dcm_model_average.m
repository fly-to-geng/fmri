% DCM 模型平均
file_root = 'D:\FMRI_ROOT\YIYU\first_level\'
cd(file_root);
subjects = dir('sub10*');
HC_num = 26;
DMN_HC = cell(HC_num,1);
DAN_HC = cell(HC_num,1);
SN_HC = cell(HC_num,1);
for i=1:HC_num
    DMN_HC{i} = fullfile(file_root,subjects(i).name,'DCM_DMN.mat');
    DAN_HC{i} = fullfile(file_root,subjects(i).name,'DCM_DAN_1.mat');
    SN_HC{i} = fullfile(file_root,subjects(i).name,'DCM_SN_1.mat');
end
spm_dcm_average(DMN_HC,'dmn_hc');
spm_dcm_average(DAN_HC,'dan_hc');
spm_dcm_average(SN_HC,'sn_hc');


MDD_num = 21;
DMN_MDD = cell(MDD_num,1);
DAN_MDD = cell(MDD_num,1);
SN_MDD = cell(MDD_num,1);
for i=HC_num+1:HC_num+MDD_num
    DMN_MDD{i-HC_num} = fullfile(file_root,subjects(i).name,'DCM_DMN.mat');
    DAN_MDD{i-HC_num} = fullfile(file_root,subjects(i).name,'DCM_DAN_1.mat');
    SN_MDD{i-HC_num} = fullfile(file_root,subjects(i).name,'DCM_SN_1.mat');
end
spm_dcm_average(DMN_MDD,'dmn_mdd');
spm_dcm_average(DAN_MDD,'dan_mdd');
spm_dcm_average(SN_MDD,'sn_mdd');