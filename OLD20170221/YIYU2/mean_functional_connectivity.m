% 分组求平均的功能连接矩阵
conectivity_matrixs = 'D:\FMRI_ROOT\YIYU\MVPA\subjects_funtional_conectivity_matrix_second_level_DMN_DAN_SN.mat';
names = 'D:\FMRI_ROOT\YIYU\MVPA\subjects_funtional_conectivity_matrix_second_level_DMN_DAN_SN_vs_names.mat';
save_path = 'D:\FMRI_ROOT\YIYU\MVPA\';
load(conectivity_matrixs);
load(names);
HD = subjects{1};
for i=2:26
    HD = subjects{i} + HD;
end
HD = HD / 26;
cd(save_path);
% save('HD_mean_functional_connectivity_brainnetcome_DMN_DAN_SN','HD');
% colormap(jet(80));
% pcolor(tril(HD));
% colorbar();
% 生成对应的vector, 为了在画环状图形中使用。
HD_vector = convert_matrix_to_triangle_vector(HD);
save('HD_mean_functional_connectivity_DMN_DAN_SN_vector','HD_vector');

MDD = subjects{27};
for i=28:47
    MDD = subjects{i} + MDD;
end
MDD = MDD / 21;
% colormap(jet(80));
% pcolor(tril(MDD));
% colorbar();
%save('MDD_mean_functional_connectivity_brainnetome_DMN_DAN_SN','MDD');

% 正常人 - 抑郁症患者  试试
HMD = HD - MDD;
colormap(jet(30));
pcolor(tril(HMD));
colorbar();
cd(save_path);
MDD_vector = convert_matrix_to_triangle_vector(MDD);
save('MDD_mean_functional_connectivity_DMN_DAN_SN_vector','MDD_vector');

