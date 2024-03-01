function X = extract_features_many_subjects(first_level_path)
%first_level_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\';
cd(first_level_path);
dir_path = dir('2016*');
features = cell(size(dir_path,1) * 4,1); % 需要根据DCM模型的数量配置；被试数量 * 每个被试的条件数量
for i = 1:size(dir_path,1)
   subject_path = [first_level_path,dir_path(i).name];
   cd(subject_path);
   dcm_models_path = dir('DCM*');
   for j = 1:size(dcm_models_path,1)
      dcm_model_path = [subject_path,'\',dcm_models_path(j).name];
      [path,name,exit] = fileparts(dcm_model_path) ;
      model_name_split = strsplit(name,'_');
      category_name = model_name_split{2};
      label = category_name_to_int(category_name);
      cow = extractFeatureFromDCM(dcm_model_path,label);
      features{(i-1)*4 + j} = cow ;
   end
end

X = cell2mat(features);