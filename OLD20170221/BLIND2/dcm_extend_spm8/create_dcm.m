function DCM = create_dcm(subject_path)
%功能： 定义DCM模型，需要先做完抽取VOI，在FirstLevel文件夹下面VOI_开头的文件；
%subject_path : First_Level 被试目录， eg.D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\20160716002\
%condition_name : SPM.mat 设计矩阵中定义的条件，这里用来给生成的DCM命名。
%---------------------------------------------------------------
%-配置----------------------------------------------------------
condition_name = {'JX','DW','RL','ZR'};
%Input_a : DCM模型矩阵，需要更改模型的时候，修改这个矩阵
%Input_b : 调节输入
%Input_c : 外界输入
%-配置结束------------------------------------------------------
cd(subject_path);
spmmatfile = [subject_path,'SPM.mat'];
for i = 1:size(condition_name,2)  %每次循环创建一个condition条件下的DCM模型
    name = condition_name{i}; % 生成的DCM模型的名称；
    condition_mask = [0,0,0,0];
    condition_mask(i) = 1; % 使用哪个condition作为
    TE = 0.04; %  TE 
    Input_a = [1,1,1;1,1,1;1,1,1]; % 定义DCM模型的连接矩阵
    Input_b = [0,0,0;0,0,0;0,0,0]; % 定义调节参数
    Input_c = [1;0;0]; % 定义输入参数
    
    % 获得VOI
    %------------------------------------------------
    filter = ['VOI_',condition_name{i},'_*'];
    VOIs_path = dir(filter);
    VOIs = cell(size(VOIs_path,1),1);
    for j = 1: size(VOIs_path,1)
        VOIs{j} = [subject_path,VOIs_path(j).name];
    end
    %-------------------------------------------------
    DCM = spm_dcm_specify_extend(spmmatfile,name,VOIs,condition_mask,TE,Input_a,Input_b,Input_c);
    clear name;
    clear VOIs;
    clear condition_mask;
end


