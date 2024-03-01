% 提取三个网络DCM模型的特征，同时提取每个特征对应的标签
first_level_path = 'D:\FMRI_ROOT\YIYU\first_level\';
% 三个网络的最优的DCM模型
dcm_models = {'DCM_DMN_1.mat','DCM_DAN_1.mat','DCM_SN_1.mat'};
save_path = 'D:\FMRI_ROOT\YIYU\MVPA\';
NC_subjects = {'sub1001','sub1002','sub1003',...
    'sub1004','sub1005','sub1006','sub1007',...
    'sub1008','sub1009','sub1011','sub1012',...
    'sub1012','sub1014','sub1015','sub1016',...
    'sub1017','sub1018','sub1019','sub1020',...
    'sub1021','sub1022','sub1023','sub1024',....
    'sub1025','sub1026','sub1028'};
MDD_subjects =  {'sub1030','sub1031','sub1032',...
    'sub1033','sub1034','sub1036','sub1037',...
    'sub1038','sub1039','sub1040','sub1041',...
    'sub1043','sub1044','sub1046','sub1047',...
    'sub1048','sub1049','sub1050','sub1051',...
    'sub1052','sub1053'};
NC_features = cell(size(NC_subjects,2),1);
for i = 1:size(NC_subjects,2)
    subject_vector = cell(1,size(dcm_models,2));
    for j=1:size(dcm_models,2)
        dcm_model_path = [first_level_path,NC_subjects{i},'\',dcm_models{j}];
        if ~exist(dcm_model_path,'file')
           disp([dcm_model_path,' not found. **********']); 
        end

        if exist(dcm_model_path,'file')
            disp(['extract ',NC_subjects{i},'  ',dcm_models{j},' features ....']);
            load(dcm_model_path);
            A = reshape(Ep.A,1, size(Ep.A,1) * size(Ep.A,2));
            subject_vector{j} = A;
            clear A;
        end
    end
    NC_features{i} = cell2mat(subject_vector);
end

MDD_features = cell(size(MDD_subjects,2),1);
for i = 1:size(MDD_subjects,2)
    subject_vector = cell(1,size(dcm_models,2));
    for j=1:size(dcm_models,2)
        dcm_model_path = [first_level_path,MDD_subjects{i},'\',dcm_models{j}];
        if ~exist(dcm_model_path,'file')
           disp([dcm_model_path,' not found. **********']); 
        end

        if exist(dcm_model_path,'file')
            disp(['extract ',MDD_subjects{i},'  ',dcm_models{j},' features ....']);
            load(dcm_model_path);
            A = reshape(Ep.A,1, size(Ep.A,1) * size(Ep.A,2));
            subject_vector{j} = A;
            clear A;
        end
    end
    MDD_features{i} = cell2mat(subject_vector);
end



% 添加标签
NC_label = ones(size(NC_features,1),1);
MDD_label = ones(size(MDD_features,1),1);
MDD_label(:,1) = 2;
NC_mat = [NC_label cell2mat(NC_features)];
MDD_mat = [MDD_label cell2mat(MDD_features)];
data = [NC_mat;MDD_mat];


% 抽取每个特征的描述信息
% ------------------------------------------------------------------------
first_level_path = 'D:\FMRI_ROOT\YIYU\first_level\';
dcm_models = {'DCM_DMN_1.mat','DCM_DAN_1.mat','DCM_SN_1.mat'};
node_name = cell(1,size(dcm_models,2));
for j=1:size(dcm_models,2)
    dcm_model_path = fullfile(first_level_path,'sub1001',dcm_models{j});
    if ~exist(dcm_model_path,'file')
       disp([dcm_model_path,' not found. **********']); 
    end

    if exist(dcm_model_path,'file')
        load(dcm_model_path);
        node_name{j} = convert_vector_to_vector(DCM.Y.name);
        %clear DCM Ep F Cp;
    end
end
lens = 0;
for i=1:size(node_name,2)
    lens = lens + size(node_name{i},2);
end
subjects_names = cell(1,lens);
count = 1;
for i=1:size(node_name,2)
    for j=1:size(node_name{i},2)
        subjects_names{count} = node_name{i}(j);
        count = count + 1;
    end
end
effective_feature_names = subjects_names;

cd(save_path);
save('features_vs_labels_from_DCM_DMN_DAN_SN','data');
save('features_vs_labels_from_DCM_DMN_DAN_SN_vs_names','effective_feature_names');

% 手工生成一个与功能连接特征名称相同的名称
DMN = {'dmn.PCC', 'dmn.MPFC', 'dmn.LLP', 'dmn.RLP'};
DAN = {'dan.lFEF', 'dan.rFEF', 'dan.lSPL', 'dan.rSPL'};
SN = {'sn.dACC', 'sn.lAI', 'sn.rAI'};
effective_feature_names = [convert_vector_to_vector(DMN) convert_vector_to_vector(DAN) convert_vector_to_vector(SN)];
save('features_vs_labels_from_DCM_DMN_DAN_SN_vs_names','effective_feature_names');