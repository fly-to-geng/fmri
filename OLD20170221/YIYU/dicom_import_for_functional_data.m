% -------------------------------------------------------------------------
% ���ܣ� ת������֢���ݵĹ�����
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
filter = 'sub*';
%ԭʼ�ļ�����
t2_file_num = 240;  %һ�����Ե����ļ�
%ԭʼ�ļ���Ÿ�Ŀ¼
raw_data_root = 'D:\FMRI_ROOT\YIYU\FunRaw\';
%ת���ʽ֮�����ݴ�ŵ�·��
img_hdr_root = 'D:\FMRI_ROOT\YIYU\FunImg\';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ʽת�����֣�ת����ɵ��ļ���������ĵ����ļ��У����н��������raw_data_root
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(raw_data_root);
subExpID=dir(filter);%===========================

t2_raw_filenames = cell(t2_file_num,1); %��֤��������t2�ļ�������
for i=1:size(subExpID,1)
    cd ([raw_data_root,subExpID(i).name]);%�л��������ļ���
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


