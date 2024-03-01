function dicom_import(filter)
% -------------------------------------------------------------------------
% 功能： 格式转换，DICOM --> HDR_IMG
% 调用： dicom_import(filter)
% 参数： 
%   filter:控制处理的被试数量，例如'20161001*'
% 示例：
%   filter = '20161001*';
%   dicom_import(filter);
% 说明：只针对当前的实验，对不同的实验需要修改函数中T1像和T2像的数量
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
%原始文件总数
t2_file_num = 1108;  %一个被试的总文件
%原始文件存放根目录
raw_data_root = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\raw_data\';
%转完格式之后数据存放的路径
img_hdr_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\img_hdr\'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%格式转换部分，转换完成的文件放在另外的单独文件夹，运行结果保存在raw_data_root
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(raw_data_root);
subExpID=dir(filter);%===========================

t2_raw_filenames = cell(t2_file_num,1); %保证大于所有t2文件的总数
index = 0;
for i=1:size(subExpID,1)
     cd ([raw_data_root,subExpID(i).name]);%切换到被试文件夹
     runExpID = dir('0*_ep2d*'); %run 文件夹
     for j=1:size(runExpID,1)
        cd ([raw_data_root,subExpID(i).name,'\',runExpID(j).name]);%切换到run文件夹
        filenames = dir('00*');
        for k=1:size(filenames,1)
            index = index + 1;
            t2_raw_filenames{index} = [raw_data_root,subExpID(i).name,'\',runExpID(j).name,'\',filenames(k).name];
        end
     end
end

spm_jobman('initcfg')
%%================================batch-begin===================================================%%
matlabbatch{1}.spm.util.dicom.data = t2_raw_filenames;
matlabbatch{1}.spm.util.dicom.root = 'patid';
matlabbatch{1}.spm.util.dicom.outdir = img_hdr_path;
matlabbatch{1}.spm.util.dicom.convopts.format = 'img';
matlabbatch{1}.spm.util.dicom.convopts.icedims = 0;
%%================================batch-end===================================================%%
DicomT2Result = spm_jobman('run',matlabbatch);
cd(img_hdr_path{1});
save DicomT2Result;
disp('t2 dicom to img_hdr sucessful!')
clear matlabbatch



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%修改这两个变量，就可以处理多个被试的数据。
%filter = '20161024002*';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%原始文件总数
t1_file_num = 176;
%原始文件存放根目录
raw_data_root = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\raw_data\';
%转完格式之后数据存放的路径
img_hdr_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\img_hdr\'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(raw_data_root);
subExpID=dir(filter);%===========================

t1_raw_filenames = cell(t1_file_num,1); %保证大于所有t2文件的总数
index = 0;
for i=1:size(subExpID,1)
     cd ([raw_data_root,subExpID(i).name]);%切换到被试文件夹
     runExpID = dir('0*_t1*'); %run 文件夹
     for j=1:size(runExpID,1)
        cd ([raw_data_root,subExpID(i).name,'\',runExpID(j).name]);%切换到run文件夹
        filenames = dir('00*');
        for k=1:size(filenames,1)
            index = index + 1;
            t1_raw_filenames{index} = [raw_data_root,subExpID(i).name,'\',runExpID(j).name,'\',filenames(k).name];
        end
     end
end

spm_jobman('initcfg');
%%================================batch-begin===================================================%%
matlabbatch{1}.spm.util.dicom.data = t1_raw_filenames;
matlabbatch{1}.spm.util.dicom.root = 'patid';
matlabbatch{1}.spm.util.dicom.outdir = img_hdr_path;
matlabbatch{1}.spm.util.dicom.convopts.format = 'img';
matlabbatch{1}.spm.util.dicom.convopts.icedims = 0;
%%================================batch-end===================================================%%
cd(img_hdr_path{1});
DicomT1Result = spm_jobman('run',matlabbatch);
save DicomT1Result;
disp('t1 dicom to img_hdr sucessful!');
clear matlabbatch;
