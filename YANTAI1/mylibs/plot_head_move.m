function plot_head_move(filter)
% -------------------------------------------------------------------------
% 功能：批量生成被试的头动图
% 调用：plot_head_move(filter)
% 参数：
%   filter:控制处理的被试数量，例如'20161001*'
% 示例：
%   filter = '20161001*';
%   plot_head_move(filter);
% 说明：会在每个被试的文件夹下生成头动图像文件
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