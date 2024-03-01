% 抽取功能连接的特征,使用brainnetcome做的功能连接
ROI_mat_path  = 'D:\FMRI_ROOT\YIYU\CONN\conn_project02\results\secondlevel\ANALYSIS_02\AllSubjects\rest\ROI.mat';
save_path = 'D:\FMRI_ROOT\YIYU\MVPA\';
load(ROI_mat_path);
subjects_num = size(ROI(1).y,1);
regions_num = size(ROI,2);
subjects = cell(subjects_num,1); % 每个被试一个功能连接的矩阵
selected_region_names = 246; % 246个脑区
for i = 1:subjects_num
    features = cell(selected_region_names,1);
    for j=1:selected_region_names
        y = ROI(j).y;
        features{j} = y(i,1:selected_region_names); % 132个AAL脑区
    end
    subject_specific_mat = cell2mat(features);
    subjects{i} = subject_specific_mat;
end
region_names = ROI(1).names(1:selected_region_names);
%保存结果
cd(save_path);
save('subjects_funtional_conectivity_matrix_second_level_briannetome','subjects');
save('subjects_funtional_conectivity_matrix_second_level_brainnetome_vs_names','region_names');

%取上三角矩阵，抽取特征
subjects_features = cell(subjects_num,1);
for k=1:subjects_num
    subjects_features{k} = convert_matrix_to_triangle_vector(subjects{k});
end
subjects_features_mat = cell2mat(subjects_features);

%计算names
labels = ROI(1).names(1:selected_region_names);
brain_map_names = convert_matrix_to_triangle_vector_labels(labels);
cd(save_path);
save('features_from_fc_brainnetome_second_level','subjects_features_mat');
save('features_from_fc_briannetome_second_level_vs_names','brain_map_names');