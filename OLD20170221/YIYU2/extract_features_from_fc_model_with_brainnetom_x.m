% ��first level �г�ȡ������������
% 
fc_first_level_root = 'D:\FMRI_ROOT\YIYU\CONN\conn_project05\results\firstlevel\ANALYSIS_02';
save_path = 'D:\FMRI_ROOT\YIYU\CONN\conn_project05\meresult\data';
filter = 'resultsROI_Subject*';
region_num = 272;
cd(fc_first_level_root);
first_sub = dir(filter);
subjects = cell(size(first_sub,1),1);
for i=1:size(first_sub,1)
    load(first_sub(i).name);
    subjects{i} = Z(1:region_num,1:region_num);% 106��AAL����
end
region_names = names(1:132);
%������
cd(save_path);
save('subjects_funtional_conectivity_matrix_from_first_level','subjects');
save('subjects_funtional_conectivity_matrix_from_first_level_vs_names','region_names');

%ȡ�����Ǿ��󣬳�ȡ����
subjects_features = cell(size(first_sub,1),1);
for k=1:size(first_sub,1)
    subjects_features{k} = convert_matrix_to_triangle_vector(subjects{k});
end
subjects_features_mat = cell2mat(subjects_features);

%����names
labels = names(1:region_num);
brain_map_names = convert_matrix_to_triangle_vector_labels(labels);
cd(save_path);
save('features_from_fc_aal_first_level','subjects_features_mat');
save('features_from_fc_aal_first_level_vs_names','brain_map_names');


