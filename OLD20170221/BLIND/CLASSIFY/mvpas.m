function mvpas(filter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  MVPA；可以同时跑多个被试的数据。
clc;
%%%%%%%%%%%%%%%%%%%%%%
% 控制处理几个被试
%filter = 'ss2016*';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%路径信息
mvpa_path = 'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\';
mvpa_design = 'D:\FMRI_ROOT\YANTAI\DESIGN\';
pre_processing_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\';
mvpa_mask = 'D:\FMRI_ROOT\YANTAI\DESIGN\MASK\';
mask_name = {'NiftiPairs_Resliced_STG.mn.img'};
run_num = 272;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. 加载需要的实验设计数据
cd(mvpa_design);
load('a.mat');% 标记空的TR
load('tutorial_runs');%标记每个TR属于哪个run
load label;%标记每一个非空的TR表示的类别，
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. 读取功能像文件
cd(pre_processing_path);
subExpID=dir(filter);%=======================================

for  i=1:size(subExpID,1)
   
    wFuncImg_filenames = cell(run_num*4,1);    

    
    cd([pre_processing_path,subExpID(i).name]);
    tic;  %开始计时   
    subRunID = dir('ep2d*');
    for j=1:size(subRunID,1)
        cd([pre_processing_path,subExpID(i).name,'\',subRunID(j).name]);
        filenames = dir('w*.img');
        start = run_num*(j-1);
        for k=1:size(filenames,1)
            wFuncImg_filenames{start + k} = [pre_processing_path,subExpID(i).name,'\',subRunID(j).name,'\',filenames(k).name];
        end
    end

    % MVPA
    for k=1:size(mask_name,2)
        % 初始化一个被试的结构体，两个参数都是自己确定的命名
        subj = init_subj('zjl',subExpID(i).name);
        cd(mvpa_mask);
        subj = load_spm_mask(subj,[mask_name{k},'_category-selective'],mask_name{k});
        subj = load_spm_pattern(subj,'epi',[mask_name{k},'_category-selective'],wFuncImg_filenames);
        subj = init_object(subj,'selector','runs');
        subj = set_mat(subj,'selector','runs',tutorial_runs);
        subj = zscore_runs(subj,'epi','runs');
        subj = create_xvalid_indices(subj,'runs');
        before_zscore_mat = get_mat(subj,'pattern','epi')';
        after_zscore_mat = get_mat(subj,'pattern','epi_z')';
        b=1:1088;%====================================================================================================================================
        after_zscore=[b' after_zscore_mat];
        %删掉空TR,根据矩阵a中的数据
        for ii=1088:-1:1
            for jj=1:320
               if ii==a(jj,1)
                  after_zscore(ii,:)=[];
               end
            end
        end
        data_STG_raw=after_zscore(:,2:end);

        data_STG=zeros(768,size(data_STG_raw,2)+1);
        data_STG(1:768,1)=label(1:768,1);
        data_STG(1:768,2:end)=data_STG_raw(1:768,1:end);
        cd(mvpa_path);
        if ~exist(subExpID(i).name,'dir')
            mkdir(subExpID(i).name);
        end
        cd([mvpa_path,subExpID(i).name]);
        save(['data_',mask_name{k},'.mat'],'data_STG');
        clear subj;
    end
    toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end