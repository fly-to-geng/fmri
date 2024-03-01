% 将所有被试MVPA的矩阵合成一个
mvpa_path = 'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\';
subject_filter = '2016*';
mat_filter = 'data_NiftiPairs_Resliced_STG.mn.img.mat*';
mat_row = 768;
mat_col = 1622;
subject_num = 20;
cd(mvpa_path);
subjects = dir(subject_filter);
multiple_data = cell(subject_num,1);
for i = 1:size(subjects,1)
   cd([mvpa_path,subjects(i).name]);
   mat_path = dir(mat_filter); 
   mat_full_path = [mvpa_path,subjects(i).name,'\',mat_path.name];
   data = load(mat_full_path);
   s(1:mat_row,1)= i ;
   data_2 = [s data.data_STG];
   multiple_data{i} = data_2;
   clear data_2 data s ;
end
multiple_mat = cell2mat(multiple_data);
cd(mvpa_path);
save('multiple_mat','multiple_mat');