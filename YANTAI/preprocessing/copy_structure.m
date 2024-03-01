function copy_structure(origin_path,destination_path,fileFilter,varargin)
% -------------------------------------------------------------------------
% ���ܣ� ����Ŀ¼�ṹ ���� �����ļ�
% ����1��copy_structure(origin_path,destination_path,filter)
% ����2��copy_structure(origin_path,destination_path,fileFilter,subExpIDFilter)
% ����3��copy_structure(origin_path,destination_path,fileFilter,subExpIDFilter��runExpIDFilter)
% ������
%   origin_path : Ҫ���Ƶ�Ŀ¼�ṹ�ľ���·��
%   destination_path : ���ļ��о���·��
%   subExpIDFilter ����һ��Ŀ¼ͨ���
%   runExpIDFilter : �Ӷ���Ŀ¼ͨ���
%   fileFilter: ������������������Щ�ļ�
% ʾ����
%   copy_structure(origin_path,destination_path,'s4w*')
%   copy_structure(origin_path,destination_path,'s4w*','20160916001*')
%   copy_structure(origin_path,destination_path,'s4w*','20160916001*','ep2d_bold_moco_p2_rest_0006*')
% ˵���� subExpIDFilterĬ��ֵΪ'2016*';runExpIDFilter Ĭ��ֵΪ 'ep2d*'
% --------------------------------------------------------------------------
if nargin < 4
   subExpIDFilter = '2016*';% �����ļ���ͨ��� 
else
    subExpIDFilter = varargin{1};
end
if nargin < 5
    runExpIDFilter = 'ep2d*';% RUN�ļ���ͨ���
else
    runExpIDFilter = varargin{2};
end
%fileFilter = 'w*';
cd(origin_path);
subExpID=dir(subExpIDFilter); 
for i=1:size(subExpID,1)
    mkdir([destination_path,subExpID(i).name]);
    cd([origin_path,subExpID(i).name]);
    runExpID=dir(runExpIDFilter); 
    for j=1:size(runExpID,1)
        mkdir([destination_path,subExpID(i).name,'\',runExpID(j).name]);
        cd([origin_path,subExpID(i).name,'\',runExpID(j).name]);
        if nargin > 2
            copyfile(fileFilter,[destination_path,subExpID(i).name,'\',runExpID(j).name],'f');
        end
    end
end