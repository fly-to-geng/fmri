function plot_head_move(filter)
% -------------------------------------------------------------------------
% ���ܣ��������ɱ��Ե�ͷ��ͼ
% ���ã�plot_head_move(filter)
% ������
%   filter:���ƴ���ı�������������'20161001*'
% ʾ����
%   filter = '20161001*';
%   plot_head_move(filter);
% ˵��������ÿ�����Ե��ļ���������ͷ��ͼ���ļ�
% -------------------------------------------------------------------------
pre_processing_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\';
cd(pre_processing_path);
SubExpID = dir(filter);
for i=1:size(SubExpID,1)
    cd([pre_processing_path,SubExpID(i).name]);
    SubRunID = dir('ep2d*');
    for j=1:size(SubRunID,1)
        cd([pre_processing_path,SubExpID(i).name,'\',SubRunID(j).name]);
        head_move_file = dir('rp_*');
        cd([pre_processing_path,SubExpID(i).name]);
        plothm([pre_processing_path,SubExpID(i).name,'\',SubRunID(j).name,'\',head_move_file.name],['Realign_Run',num2str(j)]);
    end
end