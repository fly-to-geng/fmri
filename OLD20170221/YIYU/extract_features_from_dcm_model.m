% dcm_model_path  要提取特征的DCM模型
first_level_path = 'D:\FMRI_ROOT\YIYU\first_level\';
dcm_model_name= 'DCM_DMN_1.mat';
save_path = 'D:\FMRI_ROOT\YIYU\MVPA\';
NC_subjects = {'sub1001','sub1002','sub1003',...
    'sub1004','sub1005','sub1006','sub1007',...
    'sub1008','sub1009','sub1011',...
    'sub1012','sub1012','sub1014','sub1015',...
    'sub1016','sub1017','sub1018','sub1019',...
    'sub1020','sub1021','sub1022','sub1023',...
    'sub1024','sub1025','sub1026',...
    'sub1028'};
MDD_subjects =  {'sub1030','sub1031','sub1032',...
    'sub1033','sub1034','sub1036',...
    'sub1037','sub1038','sub1039','sub1040',...
    'sub1041','sub1043','sub1044',...
    'sub1045','sub1046','sub1047','sub1048',...
    'sub1049','sub1050','sub1051','sub1052',...
    'sub1053'};
NC_features = cell(size(NC_subjects,2),1);
for i = 1:size(NC_subjects,2)
    dcm_model_path = [first_level_path,NC_subjects{i},'\',dcm_model_name];
    if ~exist(dcm_model_path,'file')
       disp([dcm_model_path,' not found. **********']); 
    end
    
    if exist(dcm_model_path,'file')
        disp(['extract ',NC_subjects{i},' features ....']);
        load(dcm_model_path);
        A = reshape(Ep.A,1, size(Ep.A,1) * size(Ep.A,2));
        NC_features{i} = A;
        clear A;
    end
end

MDD_features = cell(size(MDD_subjects,2),1);
for i = 1:size(MDD_subjects,2)
    dcm_model_path = [first_level_path,MDD_subjects{i},'\',dcm_model_name];
    if ~exist(dcm_model_path,'file')
       disp([dcm_model_path,' not found. **********']); 
    end
    
    if exist(dcm_model_path,'file')
        disp(['extract ',MDD_subjects{i},' features ....']);
        load(dcm_model_path);
        A = reshape(Ep.A,1, size(Ep.A,1) * size(Ep.A,2));
        MDD_features{i} = A;
        clear A;
    end
end

% 添加标签
NC_label = ones(size(NC_features,1),1);
MDD_label = ones(size(MDD_features,1),1);
MDD_label(:,1) = 2;
NC_mat = [NC_label cell2mat(NC_features)]
MDD_mat = [MDD_label cell2mat(MDD_features)];
data = [NC_mat;MDD_mat];
cd(save_path);
save('YIYU_data_from_DCM_DMN_1','data');