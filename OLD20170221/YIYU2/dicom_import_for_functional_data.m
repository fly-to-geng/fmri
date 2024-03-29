% -------------------------------------------------------------------------
% 功能： 转换抑郁症数据的功能像
%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%控制处理多个被试数据，下面还有一处需要同步修改
%filter = '20161024002*';
% 配置参数：
% filter : 控制处理的被试数量
% raw_data_root : 转格式之前的文件存放的绝对路径
% img_hdr_path ：img,hdr文件存放的绝对路径
% t2_file_num ：功能像文件总数(包括所有的RUN)
% t1_file_num ：结构像文件总数
% runExpID = dir('0*_ep2d*'); run文件夹的名字
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filter = 'sub*';
%原始文件总数
t2_file_num = 240;  %一个被试的总文件
%原始文件存放根目录
raw_data_root = 'D:\FMRI_ROOT\YIYU\FunRaw\';
%转完格式之后数据存放的路径
img_hdr_root = 'D:\FMRI_ROOT\YIYU\FunImg\';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%格式转换部分，转换完成的文件放在另外的单独文件夹，运行结果保存在raw_data_root
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(raw_data_root);
subExpID=dir(filter);%===========================

t2_raw_filenames = cell(t2_file_num,1); %保证大于所有t2文件的总数
for i=1:size(subExpID,1)
    cd ([raw_data_root,subExpID(i).name]);%切换到被试文件夹
    filenames = dir('00*');
    for k=1:size(filenames,1)
            t2_raw_filenames{k} = [raw_data_root,subExpID(i).name,'\',filenames(k).name];
    end
    a = [img_hdr_root,subExpID(i).name];
    cd(img_hdr_root);
    if ~exist(subExpID(i).name,'dir')
        mkdir(subExpID(i).name);
    end
    img_hdr_path_cell = {a};
    spm_jobman('initcfg')
    %%================================batch-begin===================================================%%
    matlabbatch{1}.spm.util.dicom.data = t2_raw_filenames;
    matlabbatch{1}.spm.util.dicom.root = 'flat';
    matlabbatch{1}.spm.util.dicom.outdir = img_hdr_path_cell;
    matlabbatch{1}.spm.util.dicom.convopts.format = 'img';
    matlabbatch{1}.spm.util.dicom.convopts.icedims = 0;
    %%================================batch-end===================================================%%
    DicomT2Result = spm_jobman('run',matlabbatch);
    cd(img_hdr_path_cell{1});
    save DicomT2Result;
    disp('t2 dicom to img_hdr sucessful!')
    clear matlabbatch
end


