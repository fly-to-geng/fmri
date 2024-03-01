% 从first level 中抽取功能连接特征
% 
fc_first_level_root = 'D:\FMRI_ROOT\YIYU\CONN\conn_project01\results\firstlevel\WholeRegions\';
save_path = 'D:\FMRI_ROOT\YIYU\MVPA2\';
filter = 'resultsROI_Subject*';
cd(fc_first_level_root);
first_sub = dir(filter);
subjects = cell(size(first_sub,1),1);
for i=1:size(first_sub,1)
    load(first_sub(i).name);
    subjects{i} = Z(1:106,1:106);% 106个AAL脑区
end
region_names = names(1:106);
%保存结果
cd(save_path);
save('subjects_funtional_conectivity_matrix_from_first_level','subjects');
save('subjects_funtional_conectivity_matrix_from_first_level_vs_names','region_names');

%取上三角矩阵，抽取特征
subjects_features = cell(size(first_sub,1),1);
for k=1:size(first_sub,1)
    subjects_features{k} = convert_matrix_to_triangle_vector(subjects{k});
end
subjects_features_mat = cell2mat(subjects_features);

%计算names
labels = names(1:106);
brain_map_names = convert_matrix_to_triangle_vector_labels(labels);
cd(save_path);
save('features_from_fc_aal_first_level','subjects_features_mat');
save('features_from_fc_aal_first_level_vs_names','brain_map_names');


