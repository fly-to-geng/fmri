%function define_DCM_spm12(filter)
% 定义DAN的DCM模型
clc;clear;
filter = 'sub*';
except_cells = {'sub1010','sub1029','sub1027','sub1035','sub1042','sub1054','sub1055'};
first_level_root = 'D:\FMRI_ROOT\YIYU\first_level\';
cd(first_level_root);
subjects = dir(filter);
% 定义9个DCM模型
% ----------------------------------------------------------------
Connections = cell(1,1);
Connections{1} = [0	1	1	1;1	0	1	1;1	1	0	1;1	1	1	0];% 全连接，不包括自身节点的连接
% -------------------------------------------------------------------

for i = 1:size(subjects,1)
    disp(subjects(i).name);
    if ~any( ismember(except_cells,subjects(i).name) )
        disp([subjects(i).name,' processing ...']);
        subject_path = ([first_level_root,subjects(i).name,'\']); 
        VOIs = {[subject_path,'VOI_lFEF_1.mat'];[subject_path,'VOI_rFEF_1.mat'];[subject_path,'VOI_lSPL_1.mat'];[subject_path,'VOI_rSPL_1.mat']};
        spmmatfile = [subject_path,'SPM.mat'];
        for j=1:size(Connections,1)
             DCM_model_name = ['DAN_',int2str(j)];
             DCM = spm_dcm_specify_ui_spm12(spmmatfile,VOIs,DCM_model_name,Connections{j});
        end
       
        clear subject_path;
        clear VOIs;
        clear spmmatfile;
    end
end

clear Connections;
Connections{1} = [0	1 1;1 0 1;1 1 0];% 全连接，不包括自身节点的连接
% -------------------------------------------------------------------
% 定义SN DCM
for i = 1:size(subjects,1)
    disp(subjects(i).name);
    if ~any( ismember(except_cells,subjects(i).name) )
        disp([subjects(i).name,' processing ...']);
        subject_path = ([first_level_root,subjects(i).name,'\']); 
        VOIs = {[subject_path,'VOI_dACC_1.mat'];[subject_path,'VOI_lAI_1.mat'];[subject_path,'VOI_RAI_1.mat']};
        spmmatfile = [subject_path,'SPM.mat'];
        for j=1:size(Connections,1)
             DCM_model_name = ['SN_',int2str(j)];
             DCM = spm_dcm_specify_ui_spm12(spmmatfile,VOIs,DCM_model_name,Connections{j});
        end
       
        clear subject_path;
        clear VOIs;
        clear spmmatfile;
    end
end





