pre_processing_path = 'D:\FMRI_ROOT\YIYU\pre_processing\';
cd(pre_processing_path);
filter = 'sub*';
SubExpID = dir(filter);
for i=1:size(SubExpID,1)
    cd([pre_processing_path,SubExpID(i).name]);
    head_move_file = dir('rp_*');
    cd(pre_processing_path);
    plothm([pre_processing_path,SubExpID(i).name,'\',head_move_file.name],['Realign_Run_',SubExpID(i).name,'_',num2str(i)]);
end