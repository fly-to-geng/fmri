% 提取三个网络DCM模型的特征，同时提取每个特征对应的标签
first_level_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\CB\';
% 三个网络的最优的DCM模型
dcm_models = {'DCM_L207.mat'};
cd(first_level_path);
subjects = dir('20*');
DCM_features = cell(20,1);
label = 1;
for i = 1:size(subjects,1)
    subject_vector = cell(1,size(dcm_models,2));
    for j=1:size(dcm_models,2)
        dcm_model_path = [first_level_path,subjects(i).name,'\',dcm_models{j}];
        if ~exist(dcm_model_path,'file')
           disp([dcm_model_path,' not found. **********']); 
        end

        if exist(dcm_model_path,'file')
            disp(['extract ',subjects(i).name,'  ',dcm_models{j},' features ....']);
            DCM_features{i} = extractFeatureFromDCM(dcm_model_path,label);
        end
    end
end


% 提取三个网络DCM模型的特征，同时提取每个特征对应的标签
first_level_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\BS\';
cd(first_level_path);
subjects = dir('20*');
label = 1;
for i = 1:size(subjects,1)
    subject_vector = cell(1,size(dcm_models,2));
    for j=1:size(dcm_models,2)
        dcm_model_path = [first_level_path,subjects(i).name,'\',dcm_models{j}];
        if ~exist(dcm_model_path,'file')
           disp([dcm_model_path,' not found. **********']); 
        end

        if exist(dcm_model_path,'file')
            disp(['extract ',subjects(i).name,'  ',dcm_models{j},' features ....']);
            DCM_features{5+i} = extractFeatureFromDCM(dcm_model_path,label);
        end
    end
end


% 提取三个网络DCM模型的特征，同时提取每个特征对应的标签
first_level_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\HC\';
cd(first_level_path);
subjects = dir('20*');
label = 2;
for i = 1:size(subjects,1)
    subject_vector = cell(1,size(dcm_models,2));
    for j=1:size(dcm_models,2)
        dcm_model_path = [first_level_path,subjects(i).name,'\',dcm_models{j}];
        if ~exist(dcm_model_path,'file')
           disp([dcm_model_path,' not found. **********']); 
        end

        if exist(dcm_model_path,'file')
            disp(['extract ',subjects(i).name,'  ',dcm_models{j},' features ....']);
            DCM_features{10+i} = extractFeatureFromDCM(dcm_model_path,label);
        end
    end
end

dcm_mat = cell2mat(DCM_features);
save_path='D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\results\dcm_features.xls';
xlswrite(save_path,dcm_mat);