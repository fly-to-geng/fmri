% ��first level �г�ȡ������������
%
% ���
fc_first_level_root = 'D:\FMRI_ROOT\YANTAI\CONN\conn_project_2classz_func_brainnetome\results\firstlevel\ANALYSIS_01\';
save_path = 'D:\FMRI_ROOT\YANTAI\CONN\conn_project_2classz_func_brainnetome\classresult\';

filter = 'resultsROI_Subject*';
region_num = 246;
subject_num = 36;
%==============================
cd(fc_first_level_root);
JX_matrix = cell(subject_num,1);
DW_matrix = cell(subject_num,1);
for i=1:subject_num
    JX_path = ['resultsROI_Subject', num2str(i,'%03d'),'_Condition004.mat'];
    DW_path = ['resultsROI_Subject', num2str(i,'%03d'),'_Condition005.mat'];
    load(JX_path);
    JX_matrix{i} = Z(1:region_num,1:region_num);% region_num��AAL����
    load(DW_path);
    DW_matrix{i} = Z(1:region_num,1:region_num);% region_num��AAL����
end
region_names = names(1:region_num);
%������
cd(save_path);
% ���
save('YZ_funtional_conectivity_matrix_from_brainnetome','JX_matrix');
save('WZ_funtional_conectivity_matrix_from_brainnetome','DW_matrix');


%ȡ�����Ǿ��󣬳�ȡ����
JX_features = cell(subject_num,1);
for k=1:subject_num
    JX_features{k} = convert_matrix_to_triangle_vector(JX_matrix{k});
end
JX_features_mat = cell2mat(JX_features);

DW_features = cell(subject_num,1);
for k=1:subject_num
    DW_features{k} = convert_matrix_to_triangle_vector(DW_matrix{k});
end
DW_features_mat = cell2mat(DW_features);
% 

%����names
labels = names(1:region_num);
brain_map_names = convert_matrix_to_triangle_vector_labels(labels);
cd(save_path);

% ���
save('features_YZ_brainnetome','JX_features_mat');
save('features_WZ_brainnetome','DW_features_mat');




% �ϲ���һ����������
JX_label = ones(subject_num,1);
DW_label = ones(subject_num,1) * 2;

a =  [JX_label,JX_features_mat];
c =  [DW_label,DW_features_mat];

features_brainnetome = [a;c];

cd(save_path);
save('features_brainnetome_noise','features_brainnetome');


