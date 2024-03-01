function dicom_import(filter)
% -------------------------------------------------------------------------
% ���ܣ� ��ʽת����DICOM --> HDR_IMG
% ���ã� dicom_import(filter)
% ������ 
%   filter:���ƴ���ı�������������'20161001*'
% ʾ����
%   filter = '20161001*';
%   dicom_import(filter);
% ˵����ֻ��Ե�ǰ��ʵ�飬�Բ�ͬ��ʵ����Ҫ�޸ĺ�����T1���T2�������
%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ƴ������������ݣ����滹��һ����Ҫͬ���޸�
%filter = '20161024002*';
% ���ò�����
% filter : ���ƴ���ı�������
% raw_data_root : ת��ʽ֮ǰ���ļ���ŵľ���·��
% img_hdr_path ��img,hdr�ļ���ŵľ���·��
% t2_file_num ���������ļ�����(�������е�RUN)
% t1_file_num ���ṹ���ļ�����
% runExpID = dir('0*_ep2d*'); run�ļ��е�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ԭʼ�ļ�����
t2_file_num = 1108;  %һ�����Ե����ļ�
%ԭʼ�ļ���Ÿ�Ŀ¼
raw_data_root = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\raw_data\';
%ת���ʽ֮�����ݴ�ŵ�·��
img_hdr_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\img_hdr\'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ʽת�����֣�ת����ɵ��ļ���������ĵ����ļ��У����н��������raw_data_root
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(raw_data_root);
subExpID=dir(filter);%===========================

t2_raw_filenames = cell(t2_file_num,1); %��֤��������t2�ļ�������
index = 0;
for i=1:size(subExpID,1)
     cd ([raw_data_root,subExpID(i).name]);%�л��������ļ���
     runExpID = dir('0*_ep2d*'); %run �ļ���
     for j=1:size(runExpID,1)
        cd ([raw_data_root,subExpID(i).name,'\',runExpID(j).name]);%�л���run�ļ���
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
%�޸��������������Ϳ��Դ��������Ե����ݡ�
%filter = '20161024002*';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ԭʼ�ļ�����
t1_file_num = 176;
%ԭʼ�ļ���Ÿ�Ŀ¼
raw_data_root = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\raw_data\';
%ת���ʽ֮�����ݴ�ŵ�·��
img_hdr_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\img_hdr\'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(raw_data_root);
subExpID=dir(filter);%===========================

t1_raw_filenames = cell(t1_file_num,1); %��֤��������t2�ļ�������
index = 0;
for i=1:size(subExpID,1)
     cd ([raw_data_root,subExpID(i).name]);%�л��������ļ���
     runExpID = dir('0*_t1*'); %run �ļ���
     for j=1:size(runExpID,1)
        cd ([raw_data_root,subExpID(i).name,'\',runExpID(j).name]);%�л���run�ļ���
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
