% ��ȡ�������ӵ�����
% WholeRegions second level ��������ȡ
ROI_mat_path  = 'D:\FMRI_ROOT\YIYU\CONN\conn_project01\results\secondlevel\WholeRegions\AllSubjects\rest\ROI.mat';
save_path = 'D:\FMRI_ROOT\YIYU\MVPA\';
load(ROI_mat_path);
subjects_num = size(ROI(1).y,1);
regions_num = size(ROI,2);
subjects = cell(subjects_num,1); % ÿ������һ���������ӵľ���
selected_region_names = 132; % 132��AAL����
for i = 1:subjects_num
    features = cell(selected_region_names,1);
    for j=1:selected_region_names
        y = ROI(j).y;
        features{j} = y(i,1:132); % 132��AAL����
    end
    subject_specific_mat = cell2mat(features);
    subjects{i} = subject_specific_mat;
end
region_names = ROI(1).names(1:selected_region_names);
%������
cd(save_path);
save('subjects_funtional_conectivity_matrix_second_level','subjects');
save('subjects_funtional_conectivity_matrix_second_level_vs_names','region_names');

%ȡ�����Ǿ��󣬳�ȡ����
subjects_features = cell(subjects_num,1);
for k=1:subjects_num
    subjects_features{k} = convert_matrix_to_triangle_vector(subjects{k});
end
subjects_features_mat = cell2mat(subjects_features);

%����names
labels = ROI(1).names(1:132);
brain_map_names = convert_matrix_to_triangle_vector_labels(labels);
cd(save_path);
save('features_from_fc_aal_second_level','subjects_features_mat');
save('features_from_fc_aal_second_level_vs_names','brain_map_names');
% a = [1,2,3,4;5,6,7,8;9,10,11,12;13,14,15,16];
% b = tril(a,-1);
% c = b(b~=0);
% c = c';


% feature_mat = cell2mat(features);
% cd(save_path);
% save('features_from_FC_aal','feature_mat');
% save('feature_vs_names_aal','brain_map_names');