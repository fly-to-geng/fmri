%function define_DCM_spm12(filter)
% 使用VOI信息定义DCM模型并估计
clc;clear;
filter = 'sub1001*';
except_cells = {'sub1010','sub1029','sub1027','sub1035','sub1042','sub1054','sub1055'};
first_level_root = 'D:\FMRI_ROOT\YIYU\first_level\';
cd(first_level_root);
subjects = dir(filter);
% 定义9个DCM模型
% ----------------------------------------------------------------
Connections = cell(8,1);
Connections{1} = [0	1	1	1;1	0	1	1;1	1	0	1;1	1	1	0];% 全连接，不包括自身节点的连接
Connections{2} = [0	0	1	1;1	0	1	1;1	0	0	1;1	0	1	0];
Connections{3} = [0	1	1	1;0	0	1	1;0	1	0	1;0	1	1	0];
Connections{4} = [0	1	0	0;1	0	0	0;1	1	0	1;1	1	1	0];
Connections{5} = [0	1	1	1;1	0	1	1;1	1	0	0;1	1	0	0];
Connections{6} = [0	0	1	1;1	0	1	1;1	0	0	0;1	0	0	0];
Connections{7} = [0	1	1	1;0	0	1	1;0	1	0	0;0	1	0	0];
Connections{8} = [0	1	0	0;1	0	0	0;1	1	0	0;1	1	0	0];
Connections{9} = [1 1 1 1;1 1 1 1; 1 1 1 1; 1 1 1 1]; % 全连接包括自连接
% -------------------------------------------------------------------

for i = 1:size(subjects,1)
    disp(subjects(i).name);
    if ~any( ismember(except_cells,subjects(i).name) )
        disp([subjects(i).name,' processing ...']);
        subject_path = ([first_level_root,subjects(i).name,'\']); 
        VOIs = {[subject_path,'VOI_PCC_1.mat'];[subject_path,'VOI_mPFC_1.mat'];[subject_path,'VOI_RIPC_1.mat'];[subject_path,'VOI_LIPC_1.mat']};
        spmmatfile = [subject_path,'SPM.mat'];
        %for j=1:size(Connections,1)
             DCM_model_name = ['DMN_',int2str(1)];
             DCM = spm_dcm_specify_ui_spm12(spmmatfile,VOIs,DCM_model_name,Connections{1});
        %end
       
        clear subject_path;
        clear VOIs;
        clear spmmatfile;
    end
end





