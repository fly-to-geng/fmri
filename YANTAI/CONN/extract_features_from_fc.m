% 从first level 中抽取功能连接特征
%
% 类别
fc_first_level_root = 'D:\FMRI_ROOT\YANTAI\CONN\conn_project_4class_func_aal\results\firstlevel\ANALYSIS_01\';
save_path = 'D:\FMRI_ROOT\YANTAI\CONN\conn_project_4class_func_aal\classresult\';

filter = 'resultsROI_Subject*';
region_num = 246;
subject_num = 36;
%==============================
cd(fc_first_level_root);
JX_matrix = cell(subject_num,1);
DW_matrix = cell(subject_num,1);
RL_matrix = cell(subject_num,1);
ZR_matrix = cell(subject_num,1);
for i=1:subject_num
    JX_path = ['resultsROI_Subject', num2str(i,'%03d'),'_Condition002.mat'];
    DW_path = ['resultsROI_Subject', num2str(i,'%03d'),'_Condition003.mat'];
    RL_path = ['resultsROI_Subject', num2str(i,'%03d'),'_Condition004.mat'];
    ZR_path = ['resultsROI_Subject', num2str(i,'%03d'),'_Condition005.mat'];
    load(JX_path);
    JX_matrix{i} = Z(1:region_num,1:region_num);% region_num个AAL脑区
    load(DW_path);
    DW_matrix{i} = Z(1:region_num,1:region_num);% region_num个AAL脑区
    load(RL_path);
    RL_matrix{i} = Z(1:region_num,1:region_num);% region_num个AAL脑区
    load(ZR_path);
    ZR_matrix{i} = Z(1:region_num,1:region_num);% region_num个AAL脑区
end
region_names = names(1:region_num);
%保存结果
cd(save_path);
% 类别
save('JX_funtional_conectivity_matrix_from_brainnetome','JX_matrix');
save('DW_funtional_conectivity_matrix_from_brainnetome','DW_matrix');
save('RL_funtional_conectivity_matrix_from_brainnetome','RL_matrix');
save('ZR_funtional_conectivity_matrix_from_brainnetome','ZR_matrix');
save('funtional_conectivity_matrix_from_first_level_vs_names','region_names');


%取上三角矩阵，抽取特征
JX_features = cell(subject_num,1);
for k=1:subject_num
    JX_features{k} = convert_matrix_to_triangle_vector(JX_matrix{k});
end
JX_features_mat = cell2mat(JX_features);

RL_features = cell(subject_num,1);
for k=1:subject_num
    RL_features{k} = convert_matrix_to_triangle_vector(RL_matrix{k});
end
RL_features_mat = cell2mat(RL_features);

DW_features = cell(subject_num,1);
for k=1:subject_num
    DW_features{k} = convert_matrix_to_triangle_vector(DW_matrix{k});
end
DW_features_mat = cell2mat(DW_features);
% 
ZR_features = cell(subject_num,1);
for k=1:subject_num
    ZR_features{k} = convert_matrix_to_triangle_vector(ZR_matrix{k});
end
ZR_features_mat = cell2mat(ZR_features);

%计算names
labels = names(1:region_num);
brain_map_names = convert_matrix_to_triangle_vector_labels(labels);
cd(save_path);

% 类别
save('features_JX_brainnetome','JX_features_mat');
save('features_RL_brainnetome','RL_features_mat');
save('features_DW_brainnetome','DW_features_mat');
save('features_ZR_brainnetome','ZR_features_mat');
save('features_from_fc_aal_first_level_vs_names','brain_map_names');



% 合并成一个特征矩阵
JX_label = ones(subject_num,1);
RL_label = ones(subject_num,1) * 2;
DW_label = ones(subject_num,1) * 3;
ZR_label = ones(subject_num,1) * 4;

a =  [JX_label,JX_features_mat];
b =  [RL_label,RL_features_mat];
c =  [DW_label,DW_features_mat];
d =  [ZR_label,ZR_features_mat];

features_brainnetome = [a;b;c;d];

cd(save_path);
save('features_brainnetome','features_brainnetome');


