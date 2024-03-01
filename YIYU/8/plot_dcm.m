% 创建DCM分析的结果的相关图像
root = 'D:\FMRI_ROOT\YIYU\DCM\data';
dmn_hc = 'DCM_avg_dmn_hc.mat';
dan_hc = 'DCM_avg_dan_hc,mat';
sn_hc = 'DCM_avg_sn_hc.mat';

dmn_mdd = 'DCM_avg_dmn_mdd.mat';
dan_mdd = 'DCM_avg_dan_mdd.mat';
sn_mdd = 'DCM_avg_sn_mdd.mat';
dmnhc = load(fullfile(root,dmn_hc));
a = dmnhc.DCM.Ep.A
pcolor(a)
colorbar()

lines = zeros(1,4);
a = [a;lines]

cows = zeros(5,1);