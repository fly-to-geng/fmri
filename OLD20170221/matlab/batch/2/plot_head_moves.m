%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%需要和plothm文件在同一个文件夹下
%需要修改的变量
filter = '20161005003*';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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