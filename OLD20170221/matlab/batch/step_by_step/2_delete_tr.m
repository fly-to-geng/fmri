clear all

close all

cwd = 'd:\data_processing\jianlong\data_processing\img_hdr\';
delete_filenameID = {'*-00001-00001-*','*-00002-00002-*','*-00003-00003-*','*-00004-00004-*','*-00005-00005-*'};
cd(cwd);

subExpID=dir ('2016*');     %被试文件夹

for i=1:size(subExpID,1)
    cd ([cwd,subExpID(i).name]);
    runExpID = dir('ep2d_bold_moco_p2_rest*'); %run 文件夹
     for j=1:size(runExpID,1)
         cd ([cwd,subExpID(i).name,'\\',runExpID(j).name]);
         
         for k = 1:size(delete_filenameID,2)
             delete(cell2mat(delete_filenameID(k)));
         end
     end
end